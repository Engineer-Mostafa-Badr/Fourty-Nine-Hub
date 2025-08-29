import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class BuildCountDownTimer extends StatefulWidget {
  const BuildCountDownTimer({super.key});

  @override
  State<BuildCountDownTimer> createState() => _BuildCountDownTimerState();
}

class _BuildCountDownTimerState extends State<BuildCountDownTimer> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      lowerBound: 0.9,
      upperBound: 1,
    )..repeat(reverse: true);

  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final scale =
        // isLastMinute ? _animationController.value :
        1.0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Transform.scale(
                scale: scale,
                child: Text(
                  context.isArabic?'لا تتأخر، قد يؤثر على تقييمك':
                  "Please don't be late, it might affect your rating",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: context.isDarkMode
                        ? AppColors.whiteColor
                        : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Transform.scale(
              scale: scale,
              child: SizedBox(
                width: 50,
                child: Text(
                  '5:00',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:context.isDarkMode
                        ? AppColors.whiteColor
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
