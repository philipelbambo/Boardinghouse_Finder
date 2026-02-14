import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> checkCameraPermission() async {
    var status = await Permission.camera.status;
    return status == PermissionStatus.granted;
  }

  static Future<bool> checkLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    return status == PermissionStatus.granted;
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}