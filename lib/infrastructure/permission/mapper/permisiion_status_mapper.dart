import 'package:camera_test_task/domain/permission/enum/app_permission_status.dart';
import 'package:permission_handler/permission_handler.dart';

extension PermissionStatusMapper on PermissionStatus {
  AppPermissionStatus toAppPermissionStatus() {
    switch (this) {
      case PermissionStatus.denied:
        return AppPermissionStatus.denied;
      case PermissionStatus.granted:
        return AppPermissionStatus.granted;
      case PermissionStatus.restricted:
        return AppPermissionStatus.restricted;
      case PermissionStatus.limited:
        return AppPermissionStatus.limited;
      case PermissionStatus.permanentlyDenied:
        return AppPermissionStatus.permanentlyDenied;
      case PermissionStatus.provisional:
        return AppPermissionStatus.provisional;
    }
  }
}
