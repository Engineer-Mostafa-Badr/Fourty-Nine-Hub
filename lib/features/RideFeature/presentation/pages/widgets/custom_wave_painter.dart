import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

class AudioWavePainter extends CustomPainter {
  final List<double> amplitudes;
  final Color barColor;
  final double barWidth;
  final double spacing;

  AudioWavePainter({
    required this.amplitudes,
    required this.barColor,
    required this.barWidth,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    double x = 0;

    for (int i = 0; i < amplitudes.length; i++) {
      final amplitude = amplitudes[i];
      final barHeight = amplitude * size.height;

      final y = (size.height - barHeight) / 2;

      canvas.drawRect(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        paint,
      );

      x += barWidth + spacing;
      if (x > size.width) break;
    }
  }

  @override
  bool shouldRepaint(AudioWavePainter oldDelegate) {
    return oldDelegate.amplitudes != amplitudes;
  }
}

class AudioWaveWidget extends StatefulWidget {
  final double barWidth;
  final double spacing;
  final Color barColor;
  final int barCount;
  final bool isRecording;

  const AudioWaveWidget({
    Key? key,
    this.barWidth = 3.0,
    this.spacing = 2.0,
    this.barColor = Colors.blue,
    this.barCount = 50,
    this.isRecording = false,
  }) : super(key: key);

  @override
  _AudioWaveWidgetState createState() => _AudioWaveWidgetState();
}

class _AudioWaveWidgetState extends State<AudioWaveWidget> {
  late List<double> amplitudes;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    amplitudes = List<double>.filled(widget.barCount, 0.0, growable: true);

    if (widget.isRecording) {
      startUpdating();
    }
  }

  @override
  void didUpdateWidget(AudioWaveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && timer == null) {
      startUpdating();
    } else if (!widget.isRecording && timer != null) {
      stopUpdating();
    }
  }

  void startUpdating() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
        final newValue = math.Random().nextDouble();
        amplitudes.removeAt(0);
        amplitudes.add(newValue);
      });
    });
  }

  void stopUpdating() {
    timer?.cancel();
    timer = null;
  }

  @override
  void dispose() {
    stopUpdating();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 50),
      painter: AudioWavePainter(
        amplitudes: amplitudes,
        barColor: widget.barColor,
        barWidth: widget.barWidth,
        spacing: widget.spacing,
      ),
    );
  }
}
