import { NativeModules } from 'react-native';

type ScanType = {
  multiply(a: number, b: number): Promise<number>;
};

const { Scan } = NativeModules;

export default Scan as ScanType;
