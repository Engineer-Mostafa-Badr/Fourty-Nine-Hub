import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/custom_show_dialog.dart';

void pleaseLoginDialog(BuildContext context) {
  showAnimatedDialog(
    context,
    Container(
      decoration: BoxDecoration(
          color: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Assets.login,
            width: 100,
            height: 100,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
          const Sizer(
            height: 32,
          ),
          Row(
            children: [
              Expanded(
                child: AppButton(
                    label: LocaleKeys.login.localize,
                    textColor: context.isDarkMode
                        ? AppColors.PRIMARY_COLOR
                        : Colors.white,
                    backColor: context.isDarkMode
                        ? Colors.white
                        : AppColors.PRIMARY_COLOR,
                    onPressed: () {
                      context.go(Routes.HOME);
                    }),
              ),
              const Sizer(),
              Expanded(
                child: AppButton(
                    label: LocaleKeys.close.localize,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
