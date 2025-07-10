import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

Widget buildFloatingAction(BuildContext context, Function() onTap) {
  return CustomElevatedButton(
    onPressed: () {
      onTap();
    },
    backgoundColor: AppColors.getButtonPrimaryColor(context),
    child: Label(
      text: '${LocaleKeys.addAde.localize} +',
      style: Styles.mediumText(
        fontWeight: FontWeight.bold,
        color: AppColors.getReversedTextColor(context),
      ),
    ),
  );
}
