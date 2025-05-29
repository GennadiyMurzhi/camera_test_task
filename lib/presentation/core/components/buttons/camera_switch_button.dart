import 'package:camera_test_task/presentation/core/components/buttons/interfaces/button_callbacks.dart';
import 'package:camera_test_task/presentation/core/components/buttons/mixins/button_opacity_animation_mixin.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CameraSwitchButton extends StatefulWidget {
  final VoidCallback onPressed;

  const CameraSwitchButton({super.key, required this.onPressed});

  @override
  State<CameraSwitchButton> createState() => _CameraSwitchButtonState();
}

class _CameraSwitchButtonState extends State<CameraSwitchButton>
    with ButtonOpacityAnimationMixin, TickerProviderStateMixin
    implements ButtonCallbacks {
  late final AnimationController flipController;
  late final Animation<double> flipAnimation;
  bool _isFrontCamera = false;

  @override
  void initState() {
    super.initState();
    initAnimations(this);
    flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    flipController.addListener(_switchIsFrontCamera);
    flipAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(
        parent: flipController,
        curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    disposeAnimations();
    flipController.removeListener(_switchIsFrontCamera);
    flipController.dispose();
    super.dispose();
  }

  @override
  void onTapDown() => handleTapDown();

  @override
  void onTapUp() {
    handleTapUp();
    if (_isFrontCamera) {
      flipController.reverse();
    } else {
      flipController.forward();
    }
    widget.onPressed();
  }

  void _switchIsFrontCamera() {
    if (flipController.status == AnimationStatus.forward &&
        flipController.value >= 0.5 &&
        !_isFrontCamera) {
      setState(() => _isFrontCamera = true);
    } else if (flipController.status == AnimationStatus.reverse &&
        flipController.value <= 0.5 &&
        _isFrontCamera) {
      setState(() => _isFrontCamera = false);
    }
  }

  @override
  void onTapCancel() => handleTapCancel();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: () => onTapCancel(),
      child: SizedBox(
        width: 48,
        height: 48,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Opacity(opacity: opacityAnimation.value, child: child);
          },
          child: AnimatedBuilder(
            animation: flipController,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 0, 0.001)
                  ..rotateY(flipAnimation.value),
                alignment: Alignment.center,
                child: child,
              );
            },
            child: Icon(
              _isFrontCamera ? Icons.camera_front : Icons.camera_rear,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
