import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../core/utils/custom_show_dialog.dart';

void soonDialog(BuildContext context) {
  showAnimatedDialog(
    context,
    Container(
      decoration: BoxDecoration(
        color: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Assets.comingSoon,
            width: 100,
            height: 100,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
          const Sizer(height: 32,),
          AppButton(
              label: context.isArabic ? 'اوافق' : 'Ok',
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    ),
  );
}
