import 'package:camera/camera.dart';
import 'package:camera_test_task/domain/camera/enum/camera_facing.dart';

class CameraInitializationData {
  const CameraInitializationData(
    this.hasBackCameraFacing,
    this.hasFronCameraFacing,
    this.hasMultipleCamera,
    this.setupCameraFacing,
    this.cameraController,
  );

  final bool hasBackCameraFacing;
  final bool hasFronCameraFacing;
  final bool hasMultipleCamera;
  final CameraFacing setupCameraFacing;
  final CameraController cameraController;
}
