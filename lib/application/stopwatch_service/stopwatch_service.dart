import 'dart:async';

import 'package:camera_test_task/application/utils/time_formatters.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

const String _startTime = '00:00:00';

@lazySingleton
class StopwatchService {
  Timer? _timer;
  final Stopwatch _stopwatch = Stopwatch();
  String _time = _startTime;
  final StreamController<String> _stopwatchStreamController =
      StreamController<String>.broadcast()..add(_startTime);
  Stream<String> get stopwatchStream => _stopwatchStreamController.stream;

  void start() {
    _stopwatch.start();
    _timer = Timer.periodic(Durations.extralong4, (timer) {
      _updateTime(_stopwatch.elapsed);
    });
  }

  void _updateTime(Duration duration) {
    _time = durationToHHMMSS(duration);
    _stopwatchStreamController.add(_time);
  }

  void stop() {
    _stopAndclean();
  }

  void stopAndReset() {
    _time = _startTime;
    _stopwatchStreamController.add(_time);
    _stopAndclean();
    _stopwatch.reset();
  }

  void dispose() {
    _stopAndclean();
    _stopwatchStreamController.close();
  }

  void _stopAndclean() {
    _stopwatch.stop();
    _timer?.cancel();
    _timer = null;
  }
}
