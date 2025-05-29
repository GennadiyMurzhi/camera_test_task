import 'package:flutter/material.dart';

mixin ButtonOpacityAnimationMixin<T extends StatefulWidget> on State<T> {
  late final AnimationController controller;
  late final Animation<double> opacityAnimation;

  void initAnimations(TickerProvider vsync) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 100),
    );
    opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.7,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  void handleTapDown() {
    controller.forward();
  }

  void handleTapUp() async {
    if (controller.isAnimating) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    if (mounted) {
      controller.reverse();
    }
  }

  void handleTapCancel() {
    controller.reverse();
  }

  void disposeAnimations() {
    controller.dispose();
  }
}
