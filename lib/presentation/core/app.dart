import 'package:camera_test_task/presentation/screens/camera_screen/camera_screen.dart';
import 'package:flutter/material.dart';

class CameraApp extends StatelessWidget {
  const CameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const CameraScreen(),
    );
  }
}
