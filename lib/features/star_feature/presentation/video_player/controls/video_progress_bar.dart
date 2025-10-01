import 'package:flutter/material.dart';

/// Video progress bar widget
class VideoProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration>? onSeek;
  final Color activeColor;
  final Color inactiveColor;
  final double height;

  const VideoProgressBar({
    super.key,
    required this.position,
    required this.duration,
    this.onSeek,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.white30,
    this.height = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    if (onSeek == null) {
      // Non-interactive progress bar
      return LinearProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        backgroundColor: inactiveColor,
        valueColor: AlwaysStoppedAnimation<Color>(activeColor),
        minHeight: height,
      );
    }

    // Interactive progress bar with slider
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: height,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: height * 2),
        overlayShape: RoundSliderOverlayShape(overlayRadius: height * 3),
        activeTrackColor: activeColor,
        inactiveTrackColor: inactiveColor,
        thumbColor: activeColor,
      ),
      child: Slider(
        value: progress.clamp(0.0, 1.0),
        onChanged: (value) {
          final newPosition = Duration(
            milliseconds: (value * duration.inMilliseconds).round(),
          );
          onSeek?.call(newPosition);
        },
      ),
    );
  }
}
