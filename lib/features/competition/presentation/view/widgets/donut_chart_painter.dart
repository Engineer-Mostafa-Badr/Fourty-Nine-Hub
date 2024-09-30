import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class DonutChartPainter extends CustomPainter {
  final BuildContext context;
  final int count; // The current count
  final int max; // The maximum value

  DonutChartPainter({
    required this.context,
    required this.count,
    required this.max,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double outerRadius = size.width / 4.5;
    final double innerRadius =
        outerRadius - 45; // Adjust this to fit your design

    final Paint outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerRadius - innerRadius
      ..color = Colors.transparent;

    final Paint innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerRadius - innerRadius;

    // Calculate the percentage
    int percentage = ((count / max) * 100).toInt();

    // Define the sections (current progress and remaining)
    final List<Map<String, dynamic>> sections = [
      {'value': percentage.toDouble(), 'color': AppColors.SECONDARY_COLOR},
      {
        'value': 100 - percentage.toDouble(),
        'color': Theme.of(context).primaryColor
      },
    ];

    // Calculate total value (which will be 100 as it's a percentage)
    double total = sections.fold(
        0, (sum, item) => sum + (item['value'] as num).toDouble());

    // Draw the full donut chart
    double startAngle = -pi / 2;
    for (var section in sections) {
      final double sweepAngle = (section['value'] as num) / total * 2 * pi;
      innerPaint.color = section['color'] as Color;
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: outerRadius),
        startAngle,
        sweepAngle,
        false,
        innerPaint,
      );
      startAngle += sweepAngle;
    }

    // Draw the percentage text in the center
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$percentage%', // Display percentage as an integer
        style:
            Styles.mediumText(color: Theme.of(context).scaffoldBackgroundColor),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        size.height / 2 - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
