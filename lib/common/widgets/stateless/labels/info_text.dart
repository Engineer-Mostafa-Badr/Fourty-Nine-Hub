import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../res/style/app_colors.dart';

class AppInfoText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final double? iconHeight;
  const AppInfoText(
      {super.key, required this.text, this.textStyle, this.iconHeight});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          Assets.icon,
          height: iconHeight ?? 30,
        ),
        Expanded(
          child: Text(
            text,
            style: textStyle ??
                Styles.mediumText(
                    color: context.isDarkMode
                        ? AppColors.BG_GRAY_COLOR
                        : AppColors.black.withOpacity(0.7)),
          ),
        )
      ],
    );
  }
}
