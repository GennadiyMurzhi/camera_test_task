import 'dart:io';

import 'package:camera_test_task/domain/camera/repository/camera_repository.dart';
import 'package:camera_test_task/domain/core/usecases/save_media_usecase.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class StopVideoRecordingUsecase extends SaveMediaUsecase {
  const StopVideoRecordingUsecase(
    super._mediaRepository,
    this._cameraRepository,
  );

  final CameraRepository _cameraRepository;

  @override
  Future<File> getMediaFile() async {
    return await _cameraRepository.stopVideo();
  }
}
