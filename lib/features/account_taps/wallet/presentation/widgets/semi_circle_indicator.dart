import 'package:flutter/material.dart';

class SemicircularIndicator extends StatelessWidget {
  final Color color;
  final double progress; // Value between 0 and 1
  final double strokeWidth;
  final Widget child;

  const SemicircularIndicator({
    super.key,
    required this.color,
    required this.progress,
    required this.strokeWidth,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 100), // Adjust size as needed
      painter: SemicircularIndicatorPainter(
        color: color,
        progress: progress,
        strokeWidth: strokeWidth,
      ),
      child: Center(child: child),
    );
  }
}

class SemicircularIndicatorPainter extends CustomPainter {
  final Color color;
  final double progress; // Value between 0 and 1
  final double strokeWidth;

  SemicircularIndicatorPainter({
    required this.color,
    required this.progress,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Draw the semicircle
    canvas.drawArc(
      rect,
      -3.14, // Start angle (3.14 radians = 180 degrees)
      3.14, // Sweep angle (3.14 radians = 180 degrees)
      false,
      paint,
    );

    // Draw the progress
    final double progressAngle = 3.14 * progress;
    canvas.drawArc(
      rect,
      -3.14,
      progressAngle,
      false,
      paint..color = Colors.green, // Change color of progress
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
