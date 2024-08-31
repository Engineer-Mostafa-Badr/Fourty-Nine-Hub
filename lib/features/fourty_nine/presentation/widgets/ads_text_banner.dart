import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/const.dart';

class AdsTextBanner extends StatelessWidget {
  const AdsTextBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(color: AppColors.SECONDARY_COLOR),
      child: const MarqueeText(
        text: TextSpan(
          text: UIConst.placeholderText,
        ),
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
        speed: 30,
      ),
    );
  }
}
