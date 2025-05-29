import 'package:camera_test_task/domain/permission/repository/permission_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OpenAppSettingsUsecase {
  const OpenAppSettingsUsecase(this._permissionRepository);

  final PermissionRepository _permissionRepository;

  Future<bool> call() async {
    return await _permissionRepository.openAppSettings();
  }
}
