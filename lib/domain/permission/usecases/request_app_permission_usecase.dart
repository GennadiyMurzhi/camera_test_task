import 'package:camera_test_task/domain/permission/enum/app_permission_status.dart';
import 'package:camera_test_task/domain/permission/repository/permission_repository.dart';
import 'package:camera_test_task/domain/permission/usecases/permission_usecase_params.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RequestAppPermissionUsecase {
  const RequestAppPermissionUsecase(this._permissionRepository);

  final PermissionRepository _permissionRepository;

  Future<AppPermissionStatus> call(PermissionUsecaseParams params) async {
    return await _permissionRepository.requestPermission(params.permission);
  }
}
