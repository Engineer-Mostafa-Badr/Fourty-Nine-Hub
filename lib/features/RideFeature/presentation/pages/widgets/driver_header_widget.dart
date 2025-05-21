import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../core/utils/format_numbers.dart';
import 'font_manager.dart';

class DriverHeaderWidget extends StatelessWidget {
  final Widget rideStatusWidget;
  final String? carModel;
  final String? carColor;
  final String carImageUrl;
  final String? carName;
  final String carNumber;

  const DriverHeaderWidget({
    super.key,
    required this.rideStatusWidget,
    required this.carModel,
    required this.carColor,
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
                    if (carColor != null)
                      Text(
                        '$carColor',
                        style: const TextStyle(
                          fontSize: FontSize.s12,
                          color: Colors.grey,
                        ),
                      ),
                    if (carColor != null && carName != null)
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
                    if (carModel != null && carName != null)
                      const Text(
                        ' - ',
                        style: TextStyle(
                          fontSize: FontSize.s12,
                          color: Colors.grey,
                        ),
                      ),
                    if (carModel != null)
                      Text(
                        '$carModel',
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
  final double? arrivalTimestampMs;
  final bool isCountdown;
  final bool isInLocation;

  const DriverArrivalCountdown({
    super.key,
    required this.arrivalTimestampMs,
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
    _updateRemaining();
    if (widget.isCountdown && remaining.inSeconds > 0) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant DriverArrivalCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCountdown &&
        widget.arrivalTimestampMs?.toInt() != oldWidget.arrivalTimestampMs?.toInt()) {
      _timer?.cancel();
      _updateRemaining();
      _startTimer();
    }
  }

  void _updateRemaining() {
    final now = DateTime.now();
    final arrival = DateTime.fromMillisecondsSinceEpoch(widget.arrivalTimestampMs?.toInt() ?? 0);
    remaining = arrival.difference(now);
    if (remaining.isNegative) {
      remaining = Duration.zero;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _updateRemaining();
        if (remaining.inSeconds <= 0) {
          timer.cancel();
        }
      });
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
    return "${FormatNumbers().convertNumberToLocalizedString(minutes.toString().padLeft(2, '0'), isArabic: context.isArabic)}:${FormatNumbers().convertNumberToLocalizedString(seconds.toString().padLeft(2, '0'), isArabic: context.isArabic)}";
  }

  @override
  Widget build(BuildContext context) {
    final arrivalText = _formatDuration(remaining);

    return widget.isInLocation
        ? Text(
      context.isArabic ? "لقد وصل السائق" : "The Driver has Arrived",
      style: const TextStyle(
        fontSize: FontSize.s14,
        fontWeight: FontWeight.bold,
      ),
    )
        : Text(
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


class TripDurationCountdown extends StatefulWidget {
  final double? tripDurationSeconds;
  final bool isArabic;

  const TripDurationCountdown({
    super.key,
    required this.tripDurationSeconds,
    required this.isArabic,
  });

  @override
  State<TripDurationCountdown> createState() => _TripDurationCountdownState();
}

class _TripDurationCountdownState extends State<TripDurationCountdown> {
  late Duration remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeCountdown();
  }

  void _initializeCountdown() {
    remaining = Duration(seconds: widget.tripDurationSeconds?.toInt() ?? 0);
    if (remaining.inSeconds > 0) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remaining.inSeconds > 0) {
          remaining = remaining - const Duration(seconds: 1);
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void didUpdateWidget(covariant TripDurationCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tripDurationSeconds?.toInt() != oldWidget.tripDurationSeconds?.toInt()) {
      _timer?.cancel();
      _initializeCountdown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return "${FormatNumbers().convertNumberToLocalizedString(minutes.toString().padLeft(2, '0'), isArabic: widget.isArabic)}:"
        "${FormatNumbers().convertNumberToLocalizedString(seconds.toString().padLeft(2, '0'), isArabic: widget.isArabic)}";
  }

  @override
  Widget build(BuildContext context) {
    if (remaining.inSeconds <= 0) {
      return Text(
        widget.isArabic ? "لقد وصلت" : "You have arrived",
        style: const TextStyle(
          fontSize: FontSize.s14,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final formattedTime = _formatDuration(remaining);

    return Text(
      widget.isArabic
          ? "سوف تصل خلال $formattedTime"
          : "You’ll be Arriving in $formattedTime",
      style: const TextStyle(
        fontSize: FontSize.s14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
