import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/custom_show_dialog.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/upload_rider_images.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class CompleteRegisterScreen extends StatelessWidget {
  const CompleteRegisterScreen({super.key, required this.params});

  final UploadRiderImagesParams params;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (v, c) {
        showAnimatedDialog(
          context,
          AlertDialog(
            backgroundColor: AppColors.AUTH_CONTAINER_COLOR,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Label(
                  text: LocaleKeys.areYouSureYouWantToCloseThisWindow.localize,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: Styles.headerText(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Sizer(),
                const Sizer(),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: LocaleKeys.cancel.localize,
                        style: Styles.headerText(
                          color: AppColors.AUTH_CONTAINER_COLOR,
                        ),
                        onPressed: () {
                          context.pop();

                          // Navigator.popAndPushNamed(
                          //     context, Routes.welcomeRideRegister);
                        },
                        radius: 15,
                        backColor:
                            AppColors.PRIMARY_COLOR.withValues(alpha: .75),
                        color: Colors.white,
                      ),
                    ),
                    const Sizer(),
                    Expanded(
                      child: AppButton(
                        label: LocaleKeys.close.localize,
                        style: Styles.headerText(
                          color: AppColors.AUTH_CONTAINER_COLOR,
                        ),
                        onPressed: () {
                          context.go(Routes.RIDE_HOME);
                        },
                        radius: 15,
                        backColor: AppColors.PRIMARY_COLOR,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      child: CustomScaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: HomeAppbar(),
        ),
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
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: context.isDarkMode ? Colors.white : AppColors.black,
                  ),
                ),
                const Sizer(),
                Label(
                  text: LocaleKeys
                      .pleaseNoteThatRequestProcessingTakesPlaceDuringBusinessHours
                      .localize,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: Styles.mediumText(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: context.isDarkMode ? Colors.white : AppColors.black,
                  ),
                ),
                const Sizer(),
                const Sizer(),
                const Sizer(),
                const Sizer(),
                const Sizer(),
                AppButton(
                  label: LocaleKeys.completeRegistration.localize,
                  onPressed: () {
                    context.pushReplacement(Routes.UploadRiderImages,
                        extra: params);
                  },
                  backColor: AppColors.PRIMARY_COLOR,
                  color: AppColors.AUTH_CONTAINER_COLOR,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
