import 'package:camera_test_task/presentation/core/components/buttons/interfaces/button_callbacks.dart';
import 'package:camera_test_task/presentation/core/components/buttons/mixins/button_opacity_animation_mixin.dart';
import 'package:flutter/material.dart';

class AppIconButton extends StatefulWidget {
  const AppIconButton({required this.icon, required this.onPressed, super.key});

  final IconData icon;
  final VoidCallback onPressed;

  factory AppIconButton.gallery({required VoidCallback onPressed}) =>
      AppIconButton(icon: Icons.photo, onPressed: onPressed);

  factory AppIconButton.takePhoto({required VoidCallback onPressed}) =>
      AppIconButton(icon: Icons.add_a_photo, onPressed: onPressed);

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton>
    with SingleTickerProviderStateMixin, ButtonOpacityAnimationMixin
    implements ButtonCallbacks {
  @override
  void initState() {
    super.initState();
    initAnimations(this);
  }

  @override
  void dispose() {
    disposeAnimations();
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => onTapDown(),
        onTapUp: (_) => onTapUp(),
        onTapCancel: onTapCancel,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Opacity(opacity: opacityAnimation.value, child: child);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(widget.icon, color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
