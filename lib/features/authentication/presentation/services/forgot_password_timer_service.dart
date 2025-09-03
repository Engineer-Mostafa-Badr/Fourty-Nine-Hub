import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../../core/utils/shared_pref.dart';

class ForgotPasswordTimerService extends ChangeNotifier {
  Timer? _timer;
  DateTime? _timerEnd;
  Duration _remainingTime = Duration.zero;
  bool _isTimerActive = false;

  DateTime? get timerEnd => _timerEnd;
  Duration get remainingTime => _remainingTime;
  bool get isTimerActive => _isTimerActive;

  // Generate random timer duration (1, 3, or 5 minutes)
  Duration _generateRandomTimerDuration() {
    final random = Random();
    final seconds = [80, 180, 300][random.nextInt(3)];
    return Duration(seconds: seconds);
  }

  // Start timer with random duration
  Future<void> startTimer() async {
    final duration = _generateRandomTimerDuration();
    _timerEnd = DateTime.now().add(duration);
    
    // Save timer to shared preferences
    await CacheManager.saveForgotPasswordTimer(_timerEnd!);
    
    _isTimerActive = true;
    _startCountdown();
    notifyListeners();
  }

  // Load existing timer from shared preferences
  Future<void> loadExistingTimer() async {
    _timerEnd = await CacheManager.getForgotPasswordTimer();
    
    if (_timerEnd != null) {
      final now = DateTime.now();
      if (_timerEnd!.isAfter(now)) {
        _isTimerActive = true;
        _startCountdown();
        notifyListeners();
      } else {
        await clearTimer();
      }
    }
  }

  // Start countdown
  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (_timerEnd != null && _timerEnd!.isAfter(now)) {
        _remainingTime = _timerEnd!.difference(now);
        notifyListeners();
      } else {
        // Timer expired
        clearTimer();
      }
    });
  }

  // Clear timer
  Future<void> clearTimer() async {
    _timer?.cancel();
    _timer = null;
    _timerEnd = null;
    _remainingTime = Duration.zero;
    _isTimerActive = false;
    await CacheManager.clearForgotPasswordTimer();
    notifyListeners();
  }

  // Format remaining time as MM:SS
  String get formattedRemainingTime {
    final minutes = _remainingTime.inMinutes;
    final seconds = _remainingTime.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
