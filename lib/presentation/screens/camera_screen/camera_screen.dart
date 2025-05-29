import 'dart:async';

import 'package:camera_test_task/application/stopwatch_service/stopwatch_service.dart';
import 'package:camera_test_task/injectable.dart';
import 'package:camera_test_task/presentation/core/utils/dialog_utils.dart';
import 'package:camera_test_task/presentation/core/utils/failure_utils.dart';
import 'package:camera_test_task/presentation/screens/camera_screen/cubit/camera_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:camera_test_task/presentation/core/components/buttons/app_icon_button.dart';
import 'package:camera_test_task/presentation/core/components/buttons/camera_switch_button.dart';
import 'package:camera_test_task/presentation/core/components/buttons/capture_button.dart';
import 'package:camera_test_task/presentation/core/components/image_overlay_widget/image_overlay_widget.dart';
import 'package:camera_test_task/presentation/core/components/inicators/video_status_indicator.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  late final Stream<String> _stopwatchStream;
  late final CameraCubit _cameraCubit;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _stopwatchStream = getIt<StopwatchService>().stopwatchStream;
    _cameraCubit = getIt<CameraCubit>()..init();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _cameraCubit.onBackToApp();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      body: BlocProvider<CameraCubit>(
        create: (context) => _cameraCubit,
        child: BlocConsumer<CameraCubit, CameraState>(
          listener: (context, state) {
            handleCameraFailure(context, failure: state.failure);
            if (state.showCameraPermissionExplanation) {
              showExplanationDialog(
                context: context,
                iconData: Icons.camera_alt_outlined,
                title: 'Camera Access',
                explanation:
                    'Our app needs access to the camera so you can record video and take photos. Please grant permission.',
                actionButtonText: 'Allow',
                onActionPressed: () => _cameraCubit.onPermissionRequestAgreed(),
              );
            }
            if (state.showOpenSettingsExplanation) {
              showExplanationDialog(
                context: context,
                iconData: Icons.settings_applications_outlined,
                title: 'Camera Access Denied',
                explanation:
                    'You previously denied camera access for this app. To use this feature, please go to your device settings and grant permission manually.',
                actionButtonText: 'Open Settings',
                onActionPressed: () =>
                    _cameraCubit.onOpenSettingsExplanationAgreed(),
              );
            }
          },
          builder: (context, state) {
            if (state.isPermissionChecking) {
              return const SizedBox();
            }
            final hasCameraInitializationData =
                state.cameraInitializationData != null;
            return Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: <Widget>[
                if (hasCameraInitializationData)
                  Positioned.fill(
                    child: CameraPreview(
                      state.cameraInitializationData!.cameraController,
                    ),
                  ),
                if (state.imageOverlay != null)
                  Positioned.fill(
                    child: ImageOverlayWidget(
                      imageOverlay: state.imageOverlay!,
                    ),
                  ),
                if (state.isVideoRecordingStarted)
                  Align(
                    alignment: Alignment.topRight,
                    child: SafeArea(
                      child: VideoStatusIndicator(
                        isVideoRecording: state.isVideoRecording,
                        stopwatchStream: _stopwatchStream,
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if (hasCameraInitializationData &&
                                  state
                                      .cameraInitializationData!
                                      .hasMultipleCamera)
                                CameraSwitchButton(
                                  onPressed: _cameraCubit.onSwitchCameraPressed,
                                ),
                              AppIconButton.takePhoto(
                                onPressed: _cameraCubit.onTakePhotoPressed,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: CaptureButton(
                            key: ValueKey('CaptureButton'),
                            isVideoRecordingStarted:
                                state.isVideoRecordingStarted,
                            isVideoRecordingPause: state.isVideoRecordingPause,
                            onPressed: _cameraCubit.onPressedCaptureButton,
                            onLongPressed:
                                _cameraCubit.onLongPressedCaptureButton,
                          ),
                        ),
                        Expanded(
                          child: AppIconButton.gallery(
                            onPressed: _cameraCubit.onPickeOverlayPressed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
