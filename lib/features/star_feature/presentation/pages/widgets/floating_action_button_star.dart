import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/widgets/create_star.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../core/localization/locale_keys.g.dart';

class FloatingActionButtonStar extends StatelessWidget {
  const FloatingActionButtonStar({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(

      onPressed: () {
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
