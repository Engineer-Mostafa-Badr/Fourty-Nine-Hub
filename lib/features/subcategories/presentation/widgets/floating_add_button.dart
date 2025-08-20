import 'package:flutter/material.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../custom_page/presentation/page/widget/edit_page.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../helpers/manage_vibration.dart';

Widget buildFloatingAction(BuildContext context, Function() onTap) {
  return CustomElevatedButton(
    onPressed: () {
      ManageVibration.vibrate();
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