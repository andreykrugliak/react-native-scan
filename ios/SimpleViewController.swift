//
//  SimpleViewController.swift
//  Scan
//
//  Created by Tony Chen on 2021/1/9.
//  Copyright © 2021 Facebook. All rights reserved.
//

import Foundation
import UIKit
import WeScan_English

class SimpleViewController: UIViewController {

    fileprivate var resolve:RCTPromiseResolveBlock;
    fileprivate var reject:RCTPromiseRejectBlock;
    fileprivate var startScan:Bool

    init(resolve:@escaping RCTPromiseResolveBlock, reject:@escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
        self.startScan = true

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (startScan) {
            let scannerViewController = ImageScannerController(delegate: self)
            scannerViewController.modalPresentationStyle = .fullScreen
            if #available(iOS 13.0, *) {
                scannerViewController.navigationBar.tintColor = .label
            } else {
                scannerViewController.navigationBar.tintColor = .black
            }

            present(scannerViewController, animated: true)
        }
    }
}


extension SimpleViewController: ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        let code = "error"
        let message = "Error occurred: \(error)"
        assertionFailure(message)
        self.reject(code, message, nil)

        let appDelegate = UIApplication.shared.delegate!
        let viewController = (appDelegate.window!?.rootViewController)! as UIViewController
        viewController.dismiss(animated: true, completion: nil)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        var scanResult = [String:[String:String]]()

//        let croppedUrl = results.croppedScan.image.save(NSUUID().uuidString + ".png")
        let croppedPath = getDocumentsDirectory().appendingPathComponent(NSUUID().uuidString + ".jpeg")
        if let data = results.croppedScan.image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: croppedPath)
        }

        scanResult["cropped"] = [String:String]()
        let croppedImage = results.croppedScan.image
        scanResult["cropped"]!["uri"] = croppedPath.absoluteString
        scanResult["cropped"]!["height"] = (croppedImage.size.height * croppedImage.scale).description
        scanResult["cropped"]!["width"] = (croppedImage.size.width  * croppedImage.scale).description

        self.resolve(scanResult)
        startScan = false

        let appDelegate = UIApplication.shared.delegate!
        let viewController = (appDelegate.window!?.rootViewController)! as UIViewController
        viewController.dismiss(animated: true, completion: nil)
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        self.resolve("cancel scanning")
        startScan = false
        let appDelegate = UIApplication.shared.delegate!
        let viewController = (appDelegate.window!?.rootViewController)! as UIViewController
        viewController.dismiss(animated: true, completion: nil)
    }

}

extension UIImage {
    /// Save PNG in the Documents directory
    func save(_ name: String) -> URL {
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let url = URL(fileURLWithPath: path).appendingPathComponent(name)

        try! self.pngData()?.write(to: url)
        print("saved image at \(url)")
        return url
    }
}

