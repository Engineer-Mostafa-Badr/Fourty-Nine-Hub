import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class BarData {
  final String label;
  final num value;

  BarData({required this.label, required this.value});
}

class CustomBarChart extends StatelessWidget {
  final List<BarData> data;

  const CustomBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 200),
      painter: BarChartPainter(context, data: data),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<BarData> data;
  final context;

  BarChartPainter(this.context, {required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / 15;
    final maxBarHeight = size.height * 0.8;
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    // Define the gradient
    const gradient = LinearGradient(
      colors: [AppColors.SECONDARY_COLOR, AppColors.PRIMARY_COLOR],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    for (int i = 0; i < data.length; i++) {
      final barHeight = data[i].value / maxValue * maxBarHeight;
      final barX = (i * 6 + 1) * barWidth;
      final barY = size.height - barHeight;

      final rect = Rect.fromLTWH(barX, barY, barWidth, barHeight);
      final rrect = RRect.fromRectAndRadius(
        rect,
        const Radius.circular(10),
      );
      final paint = Paint()..shader = gradient.createShader(rect);

      canvas.drawRRect(rrect, paint);
      // Draw text
      final textPainter = TextPainter(
        text: TextSpan(
          text: data[i].value.toShortScale,
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 28.sp),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(barX + (barWidth - textPainter.width) / 2,
            barY - textPainter.height - 5),
      );

      final labelPainter = TextPainter(
        text: TextSpan(
          text: data[i].label,
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 30.sp),
        ),
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset(barX + (barWidth - labelPainter.width) / 2, size.height + 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
