import 'package:camera_test_task/domain/permission/enum/app_permission.dart';

class PermissionUsecaseParams {
  const PermissionUsecaseParams({required this.permission});

  final AppPermission permission;
}
