import 'package:camera_test_task/domain/camera/enum/camera_facing.dart';

class CamerasNotLoadedError extends Error {
  @override
  String toString() {
    return '''CameraRepository: To initialize the controller, cameras must be loaded first.
Call loadCameras() before initializing the controller.''';
  }
}

class NoAvailableCamerasError extends Error {
  @override
  String toString() =>
      'No cameras found on the device. CameraRepository should not be used.';
}

class CameraNotFoundError extends Error {
  final CameraFacing requestedCameraFacing;

  CameraNotFoundError(this.requestedCameraFacing);

  @override
  String toString() =>
      'CameraRepository: Requested camera ("$requestedCameraFacing") not found. '
      'Call hasCameraFacing() before using selectCamera().';
}
