import 'package:flutter/material.dart';

class BottomBarPainter extends CustomPainter {
  final Color color;
  final double radius;

  BottomBarPainter({required this.color, this.radius = 30});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2 - radius, 0)
      ..arcToPoint(
        Offset(size.width / 2 + radius, 0),
        radius: Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
