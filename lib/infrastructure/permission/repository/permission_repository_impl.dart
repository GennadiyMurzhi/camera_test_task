import 'package:camera_test_task/domain/permission/enum/app_permission.dart';
import 'package:camera_test_task/domain/permission/enum/app_permission_status.dart';
import 'package:camera_test_task/domain/permission/repository/permission_repository.dart';
import 'package:camera_test_task/infrastructure/permission/mapper/permisiion_mapper.dart';
import 'package:camera_test_task/infrastructure/permission/mapper/permisiion_status_mapper.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

@LazySingleton(as: PermissionRepository)
class PermissionRepositoryImpl implements PermissionRepository {
  @override
  Future<AppPermissionStatus> getAppPermissionStatus(
    AppPermission appPermission,
  ) async {
    final permission = appPermission.toPermission();
    final permissionStatus = await permission.status;
    return permissionStatus.toAppPermissionStatus();
  }

  @override
  Future<AppPermissionStatus> requestPermission(
    AppPermission appPermission,
  ) async {
    final ph.Permission permission = appPermission.toPermission();
    final permissionStatus = await permission.request();
    return permissionStatus.toAppPermissionStatus();
  }

  @override
  Future<bool> openAppSettings() async {
    return await ph.openAppSettings();
  }
}
