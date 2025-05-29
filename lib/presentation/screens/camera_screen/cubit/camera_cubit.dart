import 'dart:async';
import 'dart:io';

import 'package:camera_test_task/application/stopwatch_service/stopwatch_service.dart';
import 'package:camera_test_task/domain/camera/error/camera_failures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera_test_task/domain/camera/entity/camera_initialization_data.dart';
import 'package:camera_test_task/domain/camera/enum/camera_facing.dart';
import 'package:camera_test_task/domain/camera/usecases/initialize_camera_usecase.dart';
import 'package:camera_test_task/domain/camera/usecases/puse_video_recording_usecase.dart';
import 'package:camera_test_task/domain/camera/usecases/resume_video_recording_usecase.dart';
import 'package:camera_test_task/domain/camera/usecases/select_camera_usecase.dart';
import 'package:camera_test_task/domain/camera/usecases/start_video_recording_usecase.dart';
import 'package:camera_test_task/domain/camera/usecases/stop_video_recording_usecase.dart';
import 'package:camera_test_task/domain/camera/usecases/take_photo_usecase.dart';
import 'package:camera_test_task/domain/gallery/usecases/pick_image_usecase.dart';
import 'package:camera_test_task/domain/permission/enum/app_permission.dart';
import 'package:camera_test_task/domain/permission/enum/app_permission_status.dart';
import 'package:camera_test_task/domain/permission/usecases/get_app_permission_status.dart';
import 'package:camera_test_task/domain/permission/usecases/open_app_settings_usecase.dart';
import 'package:camera_test_task/domain/permission/usecases/permission_usecase_params.dart';
import 'package:camera_test_task/domain/permission/usecases/request_app_permission_usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'camera_state.dart';
part 'camera_cubit.freezed.dart';

@injectable
class CameraCubit extends Cubit<CameraState> {
  CameraCubit(
    this._getAppPermissionStatus,
    this._requestAppPermissionUsecase,
    this._initializeCameraUsecase,
    this._openAppSettingsUsecase,
    this._pickImageUsecase,
    this._selectCameraUsecase,
    this._takePhotoUsecase,
    this._startVideoRecordingUsecase,
    this._pauseVideoRecordingUsecase,
    this._resumeVideoRecordingUsecase,
    this._stopVideoRecordingUsecase,
    this._stopwatchService,
  ) : super(const CameraState());

  final GetAppPermissionStatus _getAppPermissionStatus;
  final RequestAppPermissionUsecase _requestAppPermissionUsecase;
  final InitializeCameraUsecase _initializeCameraUsecase;
  final OpenAppSettingsUsecase _openAppSettingsUsecase;
  final PickImageUsecase _pickImageUsecase;
  final SelectCameraUsecase _selectCameraUsecase;
  final TakePhotoUsecase _takePhotoUsecase;
  final StartVideoRecordingUsecase _startVideoRecordingUsecase;
  final PauseVideoRecordingUsecase _pauseVideoRecordingUsecase;
  final ResumeVideoRecordingUsecase _resumeVideoRecordingUsecase;
  final StopVideoRecordingUsecase _stopVideoRecordingUsecase;
  final StopwatchService _stopwatchService;

  late CameraFacing _currentCameraFacing;
  Completer<void>? _openSettingsCompleter;
  bool _isAction = false;

  Future<void> init() async {
    emit(state.copyWith(isPermissionChecking: true));
    await _handlePermissionAndInitializeCamera(_getAppPermissionStatus.call);
  }

  Future<void> onPermissionRequestAgreed() async {
    emit(state.copyWith(showCameraPermissionExplanation: false));
    await _handlePermissionAndInitializeCamera(
      _requestAppPermissionUsecase.call,
    );
  }

  Future<void> onOpenSettingsExplanationAgreed() async {
    emit(state.copyWith(showOpenSettingsExplanation: false));
    _openSettingsCompleter = Completer<void>();
    final isOpenedSetting = await _openAppSettingsUsecase();
    if (isOpenedSetting) {
      await _openSettingsCompleter!.future;
      await _handlePermissionAndInitializeCamera(_getAppPermissionStatus.call);
      return;
    } else {
      if (!_openSettingsCompleter!.isCompleted) {
        _openSettingsCompleter!.complete(); // Завершаем, чтобы не висеть вечно
      }
      _openSettingsCompleter = null;
    }
    emit(state.copyWith(showOpenSettingsExplanation: true));
  }

  void onBackToApp() {
    if (_openSettingsCompleter != null &&
        !_openSettingsCompleter!.isCompleted) {
      _openSettingsCompleter!.complete();
      _openSettingsCompleter = null;
    }
  }

  Future<void> _handlePermissionAndInitializeCamera(
    Future<AppPermissionStatus> Function(PermissionUsecaseParams params)
    permisionAction,
  ) async {
    final AppPermissionStatus cameraPermissionStatus = await permisionAction(
      PermissionUsecaseParams(permission: AppPermission.camera),
    );
    if (cameraPermissionStatus == AppPermissionStatus.denied) {
      emit(state.copyWith(showCameraPermissionExplanation: true));
      return;
    }
    if (cameraPermissionStatus == AppPermissionStatus.permanentlyDenied) {
      emit(state.copyWith(showOpenSettingsExplanation: true));
      return;
    }
    final cameraInitializationData = await _initializeCameraUsecase();
    _currentCameraFacing = cameraInitializationData.setupCameraFacing;
    emit(
      state.copyWith(
        isPermissionChecking: false,
        cameraInitializationData: cameraInitializationData,
      ),
    );
  }

  Future<void> onChooseOverlayPressed() async {
    _excuteLockedActionFailure(() async {
      final image = await _pickImageUsecase();
      if (image != null) {
        emit(state.copyWith(imageOverlay: image));
      }
    });
  }

  Future<void> onSwitchCameraPressed() async {
    _excuteLockedActionFailure(() async {
      emit(state.copyWith(isCameraSwitching: true));
      if (_currentCameraFacing == CameraFacing.front) {
        _currentCameraFacing = CameraFacing.back;
      } else {
        _currentCameraFacing = CameraFacing.front;
      }
      await _selectCameraUsecase(
        SelectCameraParams(cameraFacing: _currentCameraFacing),
      );
      emit(state.copyWith(isCameraSwitching: false));
    });
  }

  Future<void> onTakePhotoPressed() async {
    _excuteLockedActionFailure(() async {
      await _takePhotoUsecase();
    });
  }

  Future<void> onPickeOverlayPressed() async {
    _excuteLockedActionFailure(() async {
      final photo = await _pickImageUsecase();
      emit(state.copyWith(imageOverlay: photo));
    });
  }

  Future<void> onPressedCaptureButton() async {
    _excuteLockedActionFailure(() async {
      if (state.isVideoRecording) {
        await _stopVideoRecordingUsecase();
        emit(
          state.copyWith(
            isVideoRecording: false,
            isVideoRecordingPause: false,
            isVideoRecordingStarted: false,
          ),
        );
        _stopwatchService.stopAndReset();
        return;
      }
      if (state.isVideoRecordingPause) {
        await _resumeVideoRecordingUsecase();
        emit(state.copyWith(isVideoRecordingPause: false));
        return;
      }
      await _startVideoRecordingUsecase();
      _stopwatchService.start();
      emit(
        state.copyWith(isVideoRecording: true, isVideoRecordingStarted: true),
      );
    });
  }

  Future<void> onLongPressedCaptureButton() async {
    _excuteLockedActionFailure(() async {
      if (state.isVideoRecordingPause) {
        await _resumeVideoRecordingUsecase();
        _stopwatchService.start();
        emit(
          state.copyWith(isVideoRecording: true, isVideoRecordingPause: false),
        );
        return;
      }
      await _pauseVideoRecordingUsecase();
      emit(
        state.copyWith(isVideoRecording: false, isVideoRecordingPause: true),
      );
      _stopwatchService.stop();
    });
  }

  Future<void> _excuteLockedActionFailure(
    Future<void> Function() action,
  ) async {
    if (!_isAction) {
      try {
        _isAction = true;
        await action();
        _isAction = false;
      } catch (e) {
        _isAction = false;
        if (e is CameraFailure) {
          emit(state.copyWith(failure: e));
        } else {
          emit(state.copyWith(failure: const GeneralFailure()));
        }
        Future.delayed(Duration(milliseconds: 300));
        emit(state.copyWith(failure: null));
      }
    }
  }

  @override
  Future<void> close() async {
    _openSettingsCompleter?.complete();
    _stopwatchService.dispose();
    await state.cameraInitializationData?.cameraController.dispose();
    return super.close();
  }
}
