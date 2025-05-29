import 'dart:io';

import 'package:flutter/material.dart';

class ImageOverlayWidget extends StatelessWidget {
  const ImageOverlayWidget({super.key, required this.imageOverlay});

  final File imageOverlay;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.2,
      child: Image.file(imageOverlay, fit: BoxFit.contain),
    );
  }
}
