import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerCard extends StatefulWidget {
  final DateTime targetTime;

  const CountdownTimerCard({super.key, required this.targetTime});

  @override
  State<CountdownTimerCard> createState() => _CountdownTimerCardState();
}

class _CountdownTimerCardState extends State<CountdownTimerCard> {
  late Timer _timer;
  Duration _remaining = Duration.zero;
  bool _isExpired = false;

  @override
  void initState() {
    print("widget.targetTime ${widget.targetTime}");
    super.initState();
    _startCountdown(widget.targetTime);
  }

  @override
  void didUpdateWidget(covariant CountdownTimerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetTime != oldWidget.targetTime) {
      _startCountdown(widget.targetTime);
    }
  }

  void _startCountdown(DateTime targetTime) {
    final now = DateTime.now();
    if (targetTime.isAfter(now)) {
      _remaining = targetTime.difference(now);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final diff = targetTime.difference(DateTime.now());
        if (diff.isNegative) {
          timer.cancel();
          setState(() {
            _isExpired = true;
          });
        } else {
          setState(() {
            _remaining = diff;
          });
        }
      });
    } else {
      _isExpired = true;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    print("targetTime ${widget.targetTime}");
    if(_isExpired) return SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            _isExpired ? 'Expired' : _formatDuration(_remaining),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
