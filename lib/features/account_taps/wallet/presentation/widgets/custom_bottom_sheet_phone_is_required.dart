import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class CustomBottomSheetPhoneIsRequired extends StatelessWidget {
  const CustomBottomSheetPhoneIsRequired({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Label(
          text: LocaleKeys.alert.localize,
          style: Styles.headerText(
            color: AppColors.SECONDARY_COLOR_DARK2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Label(
          text: LocaleKeys.pleaseEnterYourPhoneNumber.localize,
          style: Styles.mediumText(
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: LocaleKeys.ok.localize,
                style: Styles.headerText(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
                backColor: AppColors.c0B1035,
                onPressed: () {
                  ManageVibration.vibrate();
                  Navigator.pop(context);
                  context.pushNamed(Routes.EDITPROFILE);
                },
              ),
            ),
            const SizedBox(
              width: 11,
            ),
            Expanded(
              child: AppButton(
                label: LocaleKeys.cancel.localize,
                style: Styles.headerText(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
                backColor: const Color(0xffD9D9D9),
                onPressed: () {
                  ManageVibration.vibrate();
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ],
    );
  }
}
