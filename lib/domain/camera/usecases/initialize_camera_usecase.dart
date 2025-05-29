import 'package:camera_test_task/domain/camera/entity/camera_initialization_data.dart';
import 'package:camera_test_task/domain/camera/repository/camera_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class InitializeCameraUsecase {
  const InitializeCameraUsecase(this._cameraRepository);

  final CameraRepository _cameraRepository;

  Future<CameraInitializationData> call() async {
    await _cameraRepository.loadCameras();
    return await _cameraRepository.initializeCameraController();
  }
}
