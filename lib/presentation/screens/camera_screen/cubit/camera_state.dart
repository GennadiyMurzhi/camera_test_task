part of 'camera_cubit.dart';

@freezed
abstract class CameraState with _$CameraState {
  const factory CameraState({
    @Default(false) bool isPermissionChecking,
    CameraInitializationData? cameraInitializationData,

    /// Indicates whether should show an explanation dialog
    /// informing the user why camera permission is needed.
    @Default(false) bool showCameraPermissionExplanation,

    /// Indicates whether should show a dialog prompting the user
    /// to open the device settings and manually grant the camera permission.
    @Default(false) bool showOpenSettingsExplanation,
    @Default(CameraFacing.back) CameraFacing selectedCameraFacing,
    @Default(null) File? imageOverlay,
    @Default(false) isCameraSwitching,
    // insted enum
    @Default(false) isVideoRecording,
    @Default(false) isVideoRecordingStarted,
    @Default(false) isVideoRecordingPause,
    CameraFailure? failure,
  }) = _CameraState;
}
