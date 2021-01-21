import Foundation
import UIKit

@objc(Scan)
class Scan: NSObject {

    @objc(multiply:withB:withResolver:withRejecter:)
    func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        resolve(a*b)
    }
    
    @objc(scanImage:withRejecter:)
    func scanImage(resolve:@escaping RCTPromiseResolveBlock, reject:@escaping RCTPromiseRejectBlock) -> Void {
        let appDelegate = UIApplication.shared.delegate!
        let viewController = (appDelegate.window!?.rootViewController)! as UIViewController
        
        let simpleVC = SimpleViewController(resolve: resolve, reject: reject)
        viewController.present(simpleVC, animated: true, completion: nil)
        
//        let scannerViewController = ImageScannerController(delegate: appDelegate)
//        scannerViewController.modalPresentationStyle = .fullScreen
//        let simpleVC =
    }
}
