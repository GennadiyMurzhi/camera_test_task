import 'package:camera_test_task/injectable.dart';
import 'package:camera_test_task/presentation/core/app.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const CameraApp());
}
