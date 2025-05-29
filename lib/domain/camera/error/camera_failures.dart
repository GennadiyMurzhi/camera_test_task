sealed class CameraFailure {
  const CameraFailure();
}

class GeneralFailure extends CameraFailure {
  const GeneralFailure();
}

class InitCameraFailure extends CameraFailure {
  const InitCameraFailure();
}

class NoAvailableCamerasFailure extends CameraFailure {
  const NoAvailableCamerasFailure();
}

class StartVideoRecordingFailure extends CameraFailure {
  const StartVideoRecordingFailure();
}

class PauseVideoRecordingFailure extends CameraFailure {
  const PauseVideoRecordingFailure();
}

class ResumeVideoRecordingFailure extends CameraFailure {
  const ResumeVideoRecordingFailure();
}

class StopVideoRecordingFailure extends CameraFailure {
  const StopVideoRecordingFailure();
}

class TakePhotoFailureFailure extends CameraFailure {
  const TakePhotoFailureFailure();
}

class SelectCamerFailure extends CameraFailure {
  const SelectCamerFailure();
}
