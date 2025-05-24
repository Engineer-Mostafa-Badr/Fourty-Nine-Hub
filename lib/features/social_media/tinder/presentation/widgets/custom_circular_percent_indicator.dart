import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final double radius;
  final double lineWidth;
  final double startAngle;
  final List<Color> gradientColors;
  final List<double> gradientStops;
  final Alignment gradientBegin;
  final Alignment gradientEnd;
  final double percent;
  final Color backgroundColor;
  final StrokeCap strokeCap;
  final Widget? center;

  const CustomCircularProgressIndicator({
    super.key,
    required this.radius,
    required this.lineWidth,
    this.startAngle = 0,
    required this.gradientColors,
    this.gradientStops = const [0.0, 1.0],
    this.gradientBegin = Alignment.centerLeft,
    this.gradientEnd = Alignment.centerRight,
    required this.percent,
    required this.backgroundColor,
    this.strokeCap = StrokeCap.round,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circle
          CustomPaint(
            size: Size(radius * 2, radius * 2),
            painter: CircleBackgroundPainter(
              strokeWidth: lineWidth,
              backgroundColor: backgroundColor,
            ),
          ),
          // Progress Arc
          CustomPaint(
            size: Size(radius * 2, radius * 2),
            painter: CircularProgressPainter(
              strokeWidth: lineWidth,
              progress: percent,
              progressGradient: SweepGradient(
                colors: gradientColors,
                stops: gradientStops,
                startAngle: math.pi * (startAngle / 180),
                endAngle: math.pi * 2,
                transform: GradientRotation(math.pi * (startAngle / 180)),
              ),
              startAngle: startAngle,
              strokeCap: strokeCap,
            ),
          ),
          // Center Widget
          if (center != null) center!,
        ],
      ),
    );
  }
}

class CircleBackgroundPainter extends CustomPainter {
  final double strokeWidth;
  final Color backgroundColor;

  CircleBackgroundPainter({
    required this.strokeWidth,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CircularProgressPainter extends CustomPainter {
  final double strokeWidth;
  final double progress;
  final SweepGradient progressGradient;
  final double startAngle;
  final StrokeCap strokeCap;

  CircularProgressPainter({
    required this.strokeWidth,
    required this.progress,
    required this.progressGradient,
    required this.startAngle,
    required this.strokeCap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    // Convert startAngle from degrees to radians
    final startAngleRadians = math.pi * (startAngle / 180);
    
    // Calculate sweep angle based on progress (0.0 to 1.0)
    final sweepAngle = 2 * math.pi * progress;

    final rect = Rect.fromCircle(center: center, radius: radius);

    final progressPaint = Paint()
      ..shader = progressGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap;

    canvas.drawArc(
      rect,
      startAngleRadians,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Usage example:
class CircularProgressExample extends StatelessWidget {
  final double progress;
  final String assetImage;

  const CircularProgressExample({
    Key? key,
    required this.progress,
    required this.assetImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCircularProgressIndicator(
      radius: 140.0.h,
      lineWidth: 6.0,
      startAngle: 180,
      gradientColors: [Color(0xFF0B1035), Color(0xFFFF3308)],
      gradientBegin: Alignment.topCenter,
      gradientEnd: Alignment.bottomCenter,
      gradientStops: [0.4, 0.8],
      percent: progress,
      backgroundColor: Colors.grey.shade800,
      strokeCap: StrokeCap.round,
      center: CircleAvatar(
        radius: 125.h,
        backgroundImage: AssetImage(assetImage),
      ),
    );
  }
}