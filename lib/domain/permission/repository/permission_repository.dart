import 'package:camera_test_task/domain/permission/enum/app_permission.dart';
import 'package:camera_test_task/domain/permission/enum/app_permission_status.dart';

abstract class PermissionRepository {
  Future<AppPermissionStatus> getAppPermissionStatus(AppPermission permission);

  Future<AppPermissionStatus> requestPermission(AppPermission permission);

  Future<bool> openAppSettings();
}
