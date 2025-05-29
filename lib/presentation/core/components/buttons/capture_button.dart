import 'package:camera_test_task/presentation/core/components/buttons/interfaces/button_callbacks.dart';
import 'package:camera_test_task/presentation/core/components/buttons/mixins/button_opacity_animation_mixin.dart';
import 'package:flutter/material.dart';

class CaptureButton extends StatefulWidget {
  const CaptureButton({
    super.key,
    required this.isVideoRecordingStarted,
    required this.isVideoRecordingPause,
    required this.onPressed,
    required this.onLongPressed,
  });

  final bool isVideoRecordingStarted;
  final bool isVideoRecordingPause;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;

  @override
  State<CaptureButton> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<CaptureButton>
    with TickerProviderStateMixin, ButtonOpacityAnimationMixin
    implements ButtonCallbacks {
  late final AnimationController _scaleAnimationController;
  late final Animation<double> _scaleAnimation;

  final GlobalKey _key = GlobalKey();
  bool _isOutside = false;

  void _checkIfOutside(Offset globalPosition) {
    final RenderBox box = _key.currentContext?.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    final size = box.size;
    final rect = position & size;
    final isOutside = !rect.contains(globalPosition);
    if (isOutside != _isOutside) {
      setState(() {
        _isOutside = isOutside;
      });
    }
  }

  @override
  void initState() {
    initAnimations(this);
    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.3,
    ).animate(_scaleAnimationController);
    super.initState();
  }

  @override
  void dispose() {
    disposeAnimations();
    _scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  void onTapCancel() {
    handleTapCancel();
  }

  @override
  void onTapDown() {
    handleTapDown();
  }

  @override
  void onTapUp() {
    widget.onPressed();
    handleTapUp();
  }

  void onLongPressUp() {
    if (!_isOutside) {
      widget.onLongPressed();
    }
    if (widget.isVideoRecordingPause) {
      controller.reverse();
    }
    _scaleAnimationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onTapDown: (_) => onTapDown(),
      onTapUp: widget.isVideoRecordingPause
          ? (_) => onLongPressUp()
          : (_) => onTapUp(),
      onTapCancel: onTapCancel,
      onLongPressStart: widget.isVideoRecordingStarted
          ? (_) {
              _scaleAnimationController.forward();
            }
          : null,
      onLongPressUp: widget.isVideoRecordingStarted ? onLongPressUp : null,
      onLongPressMoveUpdate: widget.isVideoRecordingStarted
          ? (details) {
              _checkIfOutside(details.globalPosition);
            }
          : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: 80,
          height: 80,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 3),
            ),
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Opacity(opacity: opacityAnimation.value, child: child);
              },
              child: Center(
                child: widget.isVideoRecordingPause
                    ? Icon(Icons.pause, color: Colors.grey)
                    : SizedBox(
                        width: 60,
                        height: 60,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
