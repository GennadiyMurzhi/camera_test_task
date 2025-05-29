import 'dart:async';

import 'package:flutter/material.dart';

class VideoStatusIndicator extends StatefulWidget {
  const VideoStatusIndicator({
    super.key,
    required this.isVideoRecording,
    required this.stopwatchStream,
  });

  final bool isVideoRecording;
  final Stream<String> stopwatchStream;

  @override
  State<VideoStatusIndicator> createState() => _VideoStatusIndicatorState();
}

class _VideoStatusIndicatorState extends State<VideoStatusIndicator> {
  late final StreamSubscription<String> _stopWatchSubscription;
  String _videoCurrentTime = '00:00:00';

  @override
  void initState() {
    _stopWatchSubscription = widget.stopwatchStream.listen((time) {
      setState(() {
        _videoCurrentTime = time;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _stopWatchSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        if (widget.isVideoRecording)
          const SizedBox.square(
            dimension: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          )
        else
          Icon(Icons.pause, color: Colors.grey, size: 24),
        SizedBox(width: 10),
        Text(_videoCurrentTime, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(width: 20),
      ],
    );
  }
}
