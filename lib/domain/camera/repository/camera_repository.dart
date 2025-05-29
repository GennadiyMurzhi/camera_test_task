import 'dart:io';

import 'package:camera_test_task/domain/camera/entity/camera_initialization_data.dart';
import 'package:camera_test_task/domain/camera/enum/camera_facing.dart';

abstract class CameraRepository {
  Future<CameraInitializationData> initializeCameraController();
  Future<void> disposeCameraController();
  Future<void> loadCameras();
  bool hasCameraFacing(CameraFacing cameraFacing);
  Future<void> selectCamera(CameraFacing cameraFacing);
  Future<void> startVideo();
  Future<void> pauseVideo();
  Future<void> resumeVideo();
  Future<File> stopVideo();
  Future<File> takePhoto();
}
