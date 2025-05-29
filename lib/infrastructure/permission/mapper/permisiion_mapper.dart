import 'package:camera_test_task/domain/permission/enum/app_permission.dart';
import 'package:permission_handler/permission_handler.dart';

extension PermissionMapper on AppPermission {
  Permission toPermission() {
    switch (this) {
      case AppPermission.camera:
        return Permission.camera;
    }
  }
}
