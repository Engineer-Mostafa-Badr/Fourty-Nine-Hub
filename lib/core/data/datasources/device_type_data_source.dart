import 'dart:io';

abstract class DeviceTypeDataSource {
  int getDeviceType();
}

class DeviceTypeDataSourceImpl implements DeviceTypeDataSource {
  @override
  int getDeviceType() {
    final deviceType = Platform.isIOS ? 1 : 2;
    return deviceType;
  }
}
