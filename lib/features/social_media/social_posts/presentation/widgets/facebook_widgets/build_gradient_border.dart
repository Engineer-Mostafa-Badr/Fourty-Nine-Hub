import 'dart:math';

import 'package:flutter/material.dart';
import '../../../../../../res/style/app_colors.dart';
import 'image_from_internet.dart';

class GradientProfileBorder extends StatelessWidget {
  final String imageUrl;
  final int segments;
  final double? borderWidth;
  final double? fullWidth;
  final double? imageWidth;
  final String? firstChar;
  final bool isViewed;

  const GradientProfileBorder({super.key, required this.imageUrl, required this.segments,this.firstChar, this.borderWidth, this.imageWidth, this.fullWidth, this.isViewed = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(fullWidth??40, fullWidth??40),
          painter: SegmentedGradientBorderPainter(segments: segments,borderWidth: borderWidth, isViewed: isViewed),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey300, width: 0.5),
                shape: BoxShape.circle,
              ),
              child: ImageFromInternet(
                image: imageUrl,
                isCircle: true,
                defaultLogo: false,
                width: imageWidth??32,
                height: imageWidth??32,
                  firstChar: firstChar,
                  charPadding:0
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SegmentedGradientBorderPainter extends CustomPainter {
  final int segments;
  final double? borderWidth;
  final bool isViewed;

  SegmentedGradientBorderPainter({required this.segments,this.borderWidth, this.isViewed = false});

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = borderWidth?? 1.3;
    final double radius = (size.width / 2) - (strokeWidth / 2);
    final Offset center = Offset(size.width / 2, size.height / 2);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -pi / 2;
    double segmentAngle = (2 * pi) / segments;

    for (int i = 0; i < segments; i++) {
      double sweep = segments == 1 ? segmentAngle : segmentAngle * 0.85;

      if (isViewed) {
        paint.shader = null;
        paint.color = Colors.grey.shade300;
      } else {
        paint.shader = const LinearGradient(
          colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      }


      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        paint,
      );

      startAngle += segmentAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}