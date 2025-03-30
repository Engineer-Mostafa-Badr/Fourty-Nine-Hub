import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'dart:math' as math;
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';

class ImageStoryInstagramHeader extends StatelessWidget {
  const ImageStoryInstagramHeader({
    super.key,
    required this.storyCount,
    required this.imageUrl,
    required this.currentSegment,
  });

  final int storyCount;
  final int currentSegment;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // الدائرة الخارجية المتقطعة
        CustomPaint(
          painter: DashedCirclePainter(
            segmentCount: storyCount,
            currentSegment: currentSegment,
            activeGradient: const LinearGradient(
              colors: [
                AppColors.c0B1035,
                Color(0xffFF3308),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            inactiveGradient: const LinearGradient(
              colors: [
                AppColors.c0B1035,
                Color(0xffFF3308),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
          ),
        ),

        // الصورة الداخلية
        ImageFromInternet(
          width: 50,
          height: 50,
          image: imageUrl,
          isCircle: true,
          fit: BoxFit.cover,
        ),
        // Container(
        //   width: 65,
        //   height: 65,
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     border: Border.all(color: Colors.white, width: 3),
        //     image: DecorationImage(
        //       image: NetworkImage(storyItemEntity.imageUrl),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

// painter مخصص لرسم دائرة متقطعة
class DashedCirclePainter extends CustomPainter {
  final int segmentCount;
  final int currentSegment;
  final Gradient activeGradient;
  final Gradient inactiveGradient;

  DashedCirclePainter({
    required this.segmentCount,
    required this.currentSegment,
    required this.activeGradient,
    required this.inactiveGradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    // حساب زاوية كل قطعة
    final double anglePerSegment = 360.0 / segmentCount;

    // رسم الدائرة المتقطعة
    for (int i = 0; i < segmentCount; i++) {
      // زاوية بداية وانتهاء القطعة
      final startAngle = -math.pi / 2 + (i * anglePerSegment * math.pi / 180);
      final sweepAngle = (anglePerSegment - 10) * math.pi / 180; // إضافة فراغ بين القطع

      // إنشاء شيدر متدرج
      final Shader gradientShader = (i <= currentSegment ? activeGradient : inactiveGradient)
          .createShader(Rect.fromCircle(center: center, radius: radius));

      // تعيين الشيدر للرسام
      paint.shader = gradientShader;

      // رسم القوس المتدرج
      canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
          paint
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}