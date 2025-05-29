import 'package:camera_test_task/domain/camera/repository/camera_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PauseVideoRecordingUsecase {
  const PauseVideoRecordingUsecase(this._cameraRepository);

  final CameraRepository _cameraRepository;

  Future<void> call() async {
    await _cameraRepository.pauseVideo();
  }
}
