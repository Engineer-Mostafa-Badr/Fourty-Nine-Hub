import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../custom_page/presentation/page/widget/edit_page.dart';
import '../../presentation_exports.dart';


class FloatingActionButtonStar extends StatelessWidget {
  const FloatingActionButtonStar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      backgoundColor: AppColors.getButtonPrimaryColor(context),
      onPressed: () {
        ManageVibration.vibrate();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateStar(),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.addTalent.localize,
            style: TextStyle(
              color: AppColors.getReversedTextColor(context),
            ),
          ),
          Sizer(width: 10),
          Icon(
            Icons.add,
            color: AppColors.getReversedTextColor(context),
          ),
        ],
      ),
    );
    // return FloatingActionButton.extended(
    //
    //   onPressed: () {
    //     ManageVibration.vibrate();
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => const CreateStar(),
    //       ),
    //     );
    //   },
    //   backgroundColor: AppColors.getButtonPrimaryColor(context),
    //   icon: Text(
    //     LocaleKeys.addTalent.localize,
    //     style: TextStyle(
    //       color: AppColors.getReversedTextColor(context),
    //     ),
    //   ),
    //   label: Icon(
    //     Icons.add,
    //     color: AppColors.getReversedTextColor(context),
    //   ),
    // );
  }
}
