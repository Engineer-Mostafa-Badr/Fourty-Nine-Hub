import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';

class GradientProfileBorder extends StatelessWidget {
  final String imageUrl;
  final int segments;
  final double? borderWidth;
  final double? fullWidth;
  final double? imageWidth;

  const GradientProfileBorder({super.key, required this.imageUrl, required this.segments, this.borderWidth, this.imageWidth, this.fullWidth});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(fullWidth??40, fullWidth??40),
          painter: SegmentedGradientBorderPainter(segments: segments,borderWidth: borderWidth),
        ),
        ImageFromInternet(
          image: imageUrl,
          isCircle: true,
          defaultLogo: false,
          width: imageWidth??30,
          height: imageWidth??30,
        ),
      ],
    );
  }
}

class SegmentedGradientBorderPainter extends CustomPainter {
  final int segments;
  final double? borderWidth;

  SegmentedGradientBorderPainter({required this.segments,this.borderWidth});

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = borderWidth??3;
    final double radius = (size.width / 2) - (strokeWidth / 2);
    final Offset center = Offset(size.width / 2, size.height / 2);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -pi / 2;
    double segmentAngle = (2 * pi) / segments;

    for (int i = 0; i < segments; i++) {
      paint.shader = const LinearGradient(
        colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle * 0.8,
        false,
        paint,
      );

      startAngle += segmentAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}