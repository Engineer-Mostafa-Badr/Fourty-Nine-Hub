import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/custom_show_dialog.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

Widget closeWidget({required BuildContext context, required Function onAcceptSaveData, required Function closeRemoveData}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      InkWell(
        onTap: () {
          bottomSheet(
            backColor: context.isDarkMode?AppColors.GREY_DARK_COLOR:AppColors.AUTH_CONTAINER_COLOR,
            context: context,
            // isDismissible: false,
            widget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Label(
                  text: LocaleKeys.doYouWantToCloseRegistration.localize,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: Styles.headerText(
                    fontWeight: FontWeight.w500,
                    fontSize: 48,
                  ),
                ),
                const Sizer(),
                Label(
                  text: LocaleKeys
                      .allTheInfoAndPicturesAreSavedYouCanContinueAnyTime
                      .localize,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: Styles.headerText(
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                  ),
                ),
                const Sizer(),
                const Sizer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppButton(
                      label: LocaleKeys.yes.localize,
                      style: Styles.headerText(
                        color: AppColors.AUTH_CONTAINER_COLOR,
                      ),
                      onPressed: onAcceptSaveData,
                      radius: 15,
                      backColor: AppColors.PRIMARY_COLOR,
                      color: Colors.white,
                    ),
                    const Sizer(),
                    AppButton(
                      label: LocaleKeys.no.localize,
                      style: Styles.headerText(
                        color: AppColors.AUTH_CONTAINER_COLOR,
                      ),
                      onPressed: () => context.pop(),
                      radius: 15,
                      backColor: AppColors.PRIMARY_COLOR.withValues(alpha: .75),
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        child: Label(
          text: LocaleKeys.close.localize,
          style: Styles.mediumText(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      InkWell(
        onTap: () {
          showAnimatedDialog(
            context,
            AlertDialog(
              backgroundColor: context.isDarkMode?AppColors.GREY_DARK_COLOR:AppColors.AUTH_CONTAINER_COLOR,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Label(
                    text:
                        LocaleKeys.areYouSureYouWantToCloseThisWindow.localize,
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
                          onPressed: closeRemoveData,
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
        child: const Icon(
          Icons.close,
          // size: ,
          color: AppColors.PRIMARY_COLOR,
        ),
      ),
    ],
  );
}
