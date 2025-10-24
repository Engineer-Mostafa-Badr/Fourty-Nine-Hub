import 'dart:async';

import 'package:flutter/foundation.dart';

/// Singleton service to manage call duration across different UI components
class CallTimerService {
  static final CallTimerService _instance = CallTimerService._internal();
  factory CallTimerService() => _instance;
  CallTimerService._internal();

  Timer? _timer;
  final ValueNotifier<Duration> duration = ValueNotifier(Duration.zero);
  bool _isRunning = false;
  DateTime? _startTime;

  bool get isRunning => _isRunning;

  void startTimer() {
    if (_isRunning) {
      print("Timer already running, not restarting. Current: ${formatDuration(duration.value)}");
      return;
    }
    
    _isRunning = true;
    _timer?.cancel();
    
    // Set the start time based on current duration
    final initialSeconds = duration.value.inSeconds;
    _startTime = DateTime.now().subtract(Duration(seconds: initialSeconds));
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Calculate elapsed time since start time
      final elapsed = DateTime.now().difference(_startTime!);
      duration.value = elapsed;
    });
    
    print("Call timer started: ${formatDuration(duration.value)}");
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    // Keep duration value unchanged
    print("Call timer paused: ${formatDuration(duration.value)}");
  }

  void resumeTimer() {
    if (_isRunning) return;
    startTimer();
  }

  void resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    duration.value = Duration.zero;
    _startTime = null;
    print("Call timer reset");
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return "$hours:$minutes:$seconds";
    } else {
      return "$minutes:$seconds";
    }
  }

  void dispose() {
    _timer?.cancel();
    _isRunning = false;
  }
}
