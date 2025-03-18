import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class CompleteRegisterScreen extends StatelessWidget {
  const CompleteRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const HomeAppbar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Assets.doneRegister,
                width: 200,
                height: 200,
              ),
              const Sizer(),
              Label(
                text: LocaleKeys.thankYouWeWillRespondWithin24Hours.localize,
                style: Styles.mediumText(
                    fontSize: 32, fontWeight: FontWeight.w800),
              ),
              const Sizer(),
              Label(
                text:
                    LocaleKeys.pleaseNoteThatRequestProcessingTakesPlaceDuringBusinessHours.localize,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: Styles.mediumText(
                    fontSize: 32, fontWeight: FontWeight.w500),
              ),
              const Sizer(),
              const Sizer(),
              const Sizer(),
              const Sizer(),
              const Sizer(),
              AppButton(
                label: LocaleKeys.completeRegistration.localize,
                onPressed: () {
                  context.pushReplacement(Routes.UploadRiderImages);
                },
                backColor: AppColors.PRIMARY_COLOR,
                color: AppColors.AUTH_CONTAINER_COLOR,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
