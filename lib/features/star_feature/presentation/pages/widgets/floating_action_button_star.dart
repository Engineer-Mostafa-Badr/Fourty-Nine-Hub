import 'package:flutter/material.dart';
import '../../../../../core/extensions/string_extension.dart';
import 'create_star.dart';
import '../../../../../res/style/app_colors.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../helpers/manage_vibration.dart';

class FloatingActionButtonStar extends StatelessWidget {
  const FloatingActionButtonStar({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(

      onPressed: () {
        ManageVibration.vibrate();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateStar(),
          ),
        );
      },
      backgroundColor: AppColors.getButtonPrimaryColor(context),
      icon: Text(
        LocaleKeys.addTalent.localize,
        style: TextStyle(
          color: AppColors.getReversedTextColor(context),
        ),
      ),
      label: Icon(
        Icons.add,
        color: AppColors.getReversedTextColor(context),
      ),
    );
  }
}