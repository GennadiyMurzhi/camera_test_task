import 'package:camera_test_task/domain/camera/enum/camera_facing.dart';
import 'package:camera_test_task/domain/camera/repository/camera_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SelectCameraUsecase {
  const SelectCameraUsecase(this._cameraRepository);

  final CameraRepository _cameraRepository;

  Future<void> call(SelectCameraParams params) async {
    if (_cameraRepository.hasCameraFacing(params.cameraFacing)) {
      await _cameraRepository.selectCamera(params.cameraFacing);
    }
  }
}

class SelectCameraParams {
  const SelectCameraParams({required this.cameraFacing});

  final CameraFacing cameraFacing;
}
