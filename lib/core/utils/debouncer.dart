import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  Debouncer({
    this.duration,
  });
  final Duration? duration;

  VoidCallback? action;
  Timer? _timer;

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(duration ?? const Duration(milliseconds: 1000), action);
  }
}
