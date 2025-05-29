import 'package:camera_test_task/domain/camera/error/camera_failures.dart';
import 'package:flutter/material.dart';

void handleCameraFailure(
  BuildContext context, {
  required CameraFailure? failure,
}) {
  if (failure != null) {
    final String message;
    switch (failure) {
      case InitCameraFailure _:
        message =
            "Failed to initialize the camera. Please check permissions and try again.";
        break;
      case NoAvailableCamerasFailure _:
        message =
            "No cameras found on this device. Please ensure a camera is connected and enabled.";
        break;
      case StartVideoRecordingFailure _:
        message =
            "Could not start video recording. Please try again or check storage space.";
        break;
      case PauseVideoRecordingFailure _:
        message = "Failed to pause video recording. Please try again.";
        break;
      case ResumeVideoRecordingFailure _:
        message = "Failed to resume video recording. Please try again.";
        break;
      case StopVideoRecordingFailure _:
        message =
            "Failed to stop video recording. The video might not have been saved correctly.";
        break;
      case TakePhotoFailureFailure _:
        message =
            "Could not take photo. Please try again or check storage space.";
        break;
      case SelectCamerFailure _:
        message = "Failed to select or switch camera. Please try again.";
        break;
      case GeneralFailure _:
        message = '';
        break;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
