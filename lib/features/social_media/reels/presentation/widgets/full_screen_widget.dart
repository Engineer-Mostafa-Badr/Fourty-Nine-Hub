import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/extensions/context_extension.dart';

import '../../../../../res/assets/assets.dart';

class FullScreenWidget extends StatelessWidget {
  const FullScreenWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 120),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: SvgPicture.asset(
            Assets.fullScreenIcon,
          ),
        ),
        //     SizedBox(width: 10),
        Text(
          context.isArabic ? "الشاشة الكاملة" : "full screen",
          style: const TextStyle(
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
