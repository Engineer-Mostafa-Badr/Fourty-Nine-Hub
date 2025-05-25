import 'package:flutter/material.dart';

import '../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../labels/label.dart';

class RatioWidget extends StatelessWidget {
  final double value;
  final Color color;
  final double size;

  const RatioWidget(
      {super.key,
      required this.value,
      this.color = AppColors.PRIMARY_COLOR,
      this.size = kToolbarHeight * .7});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        children: [
          Positioned.fill(
              child: CustomCircularProgressIndicator(
            value: value,
          )),
          Positioned.fill(
              child: Center(
            child: Label(
                text: '${(value * 100).toStringAsFixed(1)}%',
                style: Styles.smallText()),
          ))
        ],
      ),
    );
  }
}
