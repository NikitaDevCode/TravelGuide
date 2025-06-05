import '/libraries/custom_packages.dart';
class DeviceInfoService {
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    return {
      'deviceType': 'Android',
      'model': androidDeviceInfo.model,
      'osVersion': androidDeviceInfo.version.release,
      'uniqueId': androidDeviceInfo.id,
    };
  }
}