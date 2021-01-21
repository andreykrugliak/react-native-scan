# react-native-scan

react native module for scanning document based on WeScan

## Installation

```sh
npm install react-native-scan
```

## Usage

```js
import Scan from "react-native-scan";

// ...
Scan.scanImage().then(result => {
  console.log(result)
  console.log(result.cropped)
  console.log(result.scanned)
  console.log(result.enhanced)
}).catch(err => {
  console.log(err)
})
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
