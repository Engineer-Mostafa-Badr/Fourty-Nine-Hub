import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime endTime;

  const CountdownTimer({super.key, required this.endTime});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _duration;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _duration = widget.endTime.difference(DateTime.now());
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final diff = widget.endTime.difference(now);

      if (diff.isNegative) {
        _timer?.cancel();
        setState(() {
          _duration = Duration.zero;
        });
      } else {
        setState(() {
          _duration = diff;
        });
      }
    });
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _duration.inDays;
    final hours = _duration.inHours % 24;
    final minutes = _duration.inMinutes % 60;
    final seconds = _duration.inSeconds % 60;

    return Text(
      '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}',
      style:Styles.mediumText(
        fontWeight: FontWeight.w900,
        color: Color(0xff8D7731)),
    );
  }
}
