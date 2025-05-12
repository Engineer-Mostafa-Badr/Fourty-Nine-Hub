import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import 'font_manager.dart';

class DriverHeaderWidget extends StatelessWidget {
  final Widget rideStatusWidget;
  final String? carModel;
  final String carImageUrl;
  final String? carName;
  final String carNumber;

  const DriverHeaderWidget({
    super.key,
    required this.rideStatusWidget,
    required this.carModel,
    required this.carImageUrl,
    required this.carName,
    required this.carNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                rideStatusWidget,
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (carModel != null)
                      Text(
                        '$carModel',
                        style: const TextStyle(
                          fontSize: FontSize.s12,
                          color: Colors.grey,
                        ),
                      ),
                    if (carModel != null && carName != null)
                      const Text(
                        ' - ',
                        style: TextStyle(
                          fontSize: FontSize.s12,
                          color: Colors.grey,
                        ),
                      ),
                    if (carName != null)
                      Text(
                        '$carName',
                        style: const TextStyle(
                          fontSize: FontSize.s12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Image.network(
                carImageUrl,
                width: 50,
                height: 30,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 4),
              Text(
                carNumber,
                style: const TextStyle(
                  fontSize: FontSize.s12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DriverArrivalCountdown extends StatefulWidget {
  final double? arrivalInSeconds;
  final bool isCountdown;
  final bool isInLocation;

  const DriverArrivalCountdown({
    super.key,
    required this.arrivalInSeconds,
    required this.isCountdown,
    required this.isInLocation,
  });

  @override
  State<DriverArrivalCountdown> createState() => _DriverArrivalCountdownState();
}

class _DriverArrivalCountdownState extends State<DriverArrivalCountdown> {
  late Duration remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    remaining = Duration(seconds: widget.arrivalInSeconds?.toInt() ?? 0);
    if (widget.isCountdown && remaining.inSeconds > 0) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant DriverArrivalCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCountdown &&
        widget.arrivalInSeconds?.toInt() != oldWidget.arrivalInSeconds?.toInt()) {
      _timer?.cancel();
      remaining = Duration(seconds: widget.arrivalInSeconds?.toInt() ?? 0);
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remaining.inSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() {
          remaining = remaining - const Duration(seconds: 1);
          print("remaining: ${remaining.inSeconds}");
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final arrivalText = widget.isCountdown
        ? _formatDuration(remaining)
        : _formatDuration(Duration(seconds: widget.arrivalInSeconds?.toInt() ?? 0));

    return widget.isInLocation ? Text(
      context.isArabic
          ? "لقد وصل السائق"
          : "The Driver has Arrived",
      style: const TextStyle(
        fontSize: FontSize.s14,
        fontWeight: FontWeight.bold,
      ),
    ): Text(
      context.isArabic
          ? "سوف يصل السائق في $arrivalText"
          : "Driver is arriving in $arrivalText",
      style: const TextStyle(
        fontSize: FontSize.s14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
