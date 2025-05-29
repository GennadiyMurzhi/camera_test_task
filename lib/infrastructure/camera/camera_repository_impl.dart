import 'dart:io';

import 'package:camera/camera.dart';
// An unexpected problem: Can't find CameraLensType. For the solution was
// imported camera_description.dart, which is so included in camera.dart
import 'package:camera_platform_interface/src/types/camera_description.dart'
    as description;
import 'package:camera_test_task/domain/camera/entity/camera_initialization_data.dart';
import 'package:camera_test_task/domain/camera/enum/camera_facing.dart';
import 'package:camera_test_task/domain/camera/error/camera_errors.dart';
import 'package:camera_test_task/domain/camera/error/camera_failures.dart';
import 'package:camera_test_task/domain/camera/repository/camera_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CameraRepository)
class CameraRepositoryImpl implements CameraRepository {
  late final CameraController _cameraController;
  final Map<CameraFacing, CameraDescription> _cameras = {};

  @override
  Future<CameraInitializationData> initializeCameraController() async {
    try {
      if (_cameras.isEmpty) {
        throw CamerasNotLoadedError();
      }
      final CameraDescription cameraDescription;
      final CameraFacing setupCameraFacing;
      final back = _cameras[CameraFacing.back];
      final front = _cameras[CameraFacing.front];
      final hasBackCameraFacing = back != null;
      final hasFrontCameraFacing = front != null;
      final hasMultipleCamera = hasBackCameraFacing && hasFrontCameraFacing;
      if (hasBackCameraFacing) {
        setupCameraFacing = CameraFacing.back;
        cameraDescription = back;
      } else if (hasFrontCameraFacing) {
        setupCameraFacing = CameraFacing.front;
        cameraDescription = front;
      } else {
        throw (NoAvailableCamerasError());
      }
      _cameraController = CameraController(
        cameraDescription,
        ResolutionPreset.ultraHigh,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await _cameraController.initialize();
      return CameraInitializationData(
        hasBackCameraFacing,
        hasFrontCameraFacing,
        hasMultipleCamera,
        setupCameraFacing,
        _cameraController,
      );
    } catch (e) {
      throw (const InitCameraFailure());
    }
  }

  @override
  Future<void> disposeCameraController() async {
    await _cameraController.dispose();
  }

  @override
  Future<void> loadCameras() async {
    final cameraDescriptions = await availableCameras();
    if (cameraDescriptions.isEmpty) {
      throw (const NoAvailableCamerasFailure());
    }
    bool hasBackCamera = false;
    bool hasFrontCamera = false;
    for (final camera in cameraDescriptions) {
      if (camera.lensType == description.CameraLensType.wide &&
              camera.lensDirection == CameraLensDirection.back ||
          camera.lensDirection == CameraLensDirection.back) {
        _cameras[CameraFacing.back] = camera;
        hasBackCamera = true;
      }
      if (camera.lensDirection == CameraLensDirection.front) {
        _cameras[CameraFacing.front] = camera;
        hasFrontCamera = true;
      }
      if (hasBackCamera && hasFrontCamera) {
        break;
      }
    }
    if (cameraDescriptions.isEmpty) {
      throw (const NoAvailableCamerasFailure());
    }
  }

  @override
  bool hasCameraFacing(CameraFacing cameraFacing) {
    return _cameras[cameraFacing] != null;
  }

  @override
  Future<void> selectCamera(CameraFacing cameraFacing) async {
    try {
      final cameraDescription = _cameras[cameraFacing];
      if (cameraDescription == null) {
        throw (CameraNotFoundError(cameraFacing));
      }
      await _cameraController.setDescription(cameraDescription);
    } catch (e) {
      throw (const SelectCamerFailure());
    }
  }

  @override
  Future<void> startVideo() async {
    try {
      await _cameraController.startVideoRecording();
    } catch (e) {
      throw (const StartVideoRecordingFailure());
    }
  }

  @override
  Future<void> pauseVideo() async {
    try {
      await _cameraController.pauseVideoRecording();
    } catch (e) {
      throw (const PauseVideoRecordingFailure());
    }
  }

  // An unexpected problem: On Android, the issue with saving video files has not been resolved.
  // It was not possible to determine why the video files are being saved with
  // the ".temp" extension. Therefore, in the case of Android,
  // the MIME type "video/mp4" is added to the path string.
  @override
  Future<File> stopVideo() async {
    try {
      return await _getCameraXFileAsFile(
        _cameraController.stopVideoRecording,
        Platform.isAndroid ? 'mp4' : null,
      );
    } catch (e) {
      throw (const StopVideoRecordingFailure());
    }
  }

  Future<File> _getCameraXFileAsFile(
    Future<XFile> Function() getXFile, [
    String? preferredMimeType,
  ]) async {
    final xFile = await getXFile();
    if (preferredMimeType == null) {
      return File(xFile.path);
    }
    final preferredPath = '${xFile.path}.$preferredMimeType';
    await xFile.saveTo(preferredPath);
    await File(xFile.path).delete();
    return File(preferredPath);
  }

  @override
  Future<void> resumeVideo() async {
    try {
      await _cameraController.resumeVideoRecording();
    } catch (e) {
      throw (const ResumeVideoRecordingFailure());
    }
  }

  @override
  Future<File> takePhoto() async {
    try {
      return await _getCameraXFileAsFile(_cameraController.takePicture);
    } catch (e) {
      throw (const TakePhotoFailureFailure());
    }
  }
}
