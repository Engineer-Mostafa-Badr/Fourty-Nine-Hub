import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class BuildCountDownTimer extends StatefulWidget {
  final String? dateTimeString;
  
  const BuildCountDownTimer({
    super.key, 
    this.dateTimeString,
  });

  @override
  State<BuildCountDownTimer> createState() => _BuildCountDownTimerState();
}

class _BuildCountDownTimerState extends State<BuildCountDownTimer> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  Timer? _timer;
  Duration _remainingTime = Duration.zero;
  DateTime? _targetDateTime;
  String? _lastReceivedDateTime;
  bool _hasValidTime = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      lowerBound: 0.9,
      upperBound: 1,
    )..repeat(reverse: true);

    _initializeTimer();
  }

  @override
  void didUpdateWidget(BuildCountDownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if we received a new updated time
    if (widget.dateTimeString != null && 
        widget.dateTimeString!.isNotEmpty &&
        widget.dateTimeString != _lastReceivedDateTime) {
      _lastReceivedDateTime = widget.dateTimeString;
      _updateTimer(widget.dateTimeString!);
    } else if (widget.dateTimeString == null || widget.dateTimeString!.isEmpty) {
      // Stop timer if time is null or empty
      _stopTimer();
    }
  }

  void _initializeTimer() {
    if (widget.dateTimeString != null && widget.dateTimeString!.isNotEmpty) {
      _lastReceivedDateTime = widget.dateTimeString;
      _updateTimer(widget.dateTimeString!);
    } else {
      // Don't start timer if no valid time provided
      _stopTimer();
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _hasValidTime = false;
    _remainingTime = Duration.zero;
    setState(() {});
  }

  void _updateTimer(String dateTimeString) {
    try {
      // Parse the DateTime string and convert to local time
      DateTime targetTime = DateTime.parse(dateTimeString).toLocal();
      DateTime now = DateTime.now();
      
      // Calculate the difference
      Duration difference = targetTime.difference(now);
      
      // If the target time is in the future
      if (difference.isNegative) {
        // Target time has passed, set to 0
        _startTimer(Duration.zero);
      } else {
        // Use the actual difference (no 5-minute cap)
        _startTimer(difference);
      }
      
      _targetDateTime = targetTime;
      _hasValidTime = true;
    } catch (e) {
      print('Error parsing DateTime: $e');
      // Don't start timer on error
      _stopTimer();
    }
  }

  void _startTimer(Duration duration) {
    _timer?.cancel();
    _remainingTime = duration;
    _hasValidTime = true;
    
    if (duration.inSeconds > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingTime.inSeconds > 0) {
            _remainingTime = _remainingTime - const Duration(seconds: 1);
          } else {
            timer.cancel();
            _remainingTime = Duration.zero;
          }
        });
      });
    }
  }

  String _formatTime(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(1, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  bool get _isLastMinute => _remainingTime.inMinutes < 1;

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Don't show anything if no valid time
    if (!_hasValidTime) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final scale = _isLastMinute ? _animationController.value : 1.0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Transform.scale(
                scale: scale,
                child: Text(
                  context.isArabic ? 'لا تتأخر، قد يؤثر على تقييمك' :
                  "Please don't be late, it might affect your rating",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: context.isDarkMode
                        ? AppColors.whiteColor
                        : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Transform.scale(
              scale: scale,
              child: SizedBox(
                width: _remainingTime.inHours > 0 ? 70 : 50, // Adjust width for hours
                child: Text(
                  _formatTime(_remainingTime),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isLastMinute 
                        ? Colors.red 
                        : (context.isDarkMode
                            ? AppColors.whiteColor
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
