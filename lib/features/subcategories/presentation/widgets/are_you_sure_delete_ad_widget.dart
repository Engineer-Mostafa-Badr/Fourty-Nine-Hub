import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class AreYouSureDeleteAdWidget extends StatelessWidget {
  final String title, subTitle;
  final Function action;
  final EdgeInsetsGeometry? padding;

  const AreYouSureDeleteAdWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.action,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
          // shrinkWrap: true,
          mainAxisSize: MainAxisSize.min,
          children: [
            Label(
              text: title,
              style: Styles.headerText(
                fontWeight: FontWeight.w700,
                color: context.isDarkMode
                    ? const Color(0xffF45560)
                    : AppColors.SECONDARY_COLOR_DARK2,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Label(
              text: subTitle,
              maxLines: 2,
              style: Styles.mediumText(
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                      backColor: context.isDarkMode
                          ? const Color(0xffF45560)
                          : AppColors.SECONDARY_COLOR_DARK2,
                      label: LocaleKeys.deleteAd.localize,
                      style: Styles.headerText(
                        fontWeight: FontWeight.w500,
                        color: context.isDarkMode
                            ? const Color(0xff0D0D0D)
                            : Colors.white,
                      ),
                      onPressed: () {
                        action();
                        context.pop();
                      }),
                ),
                const SizedBox(
                  width: 11,
                ),
                Expanded(
                  child: AppButton(
                      backColor: AppColors.PRIMARY_COLOR,
                      label: LocaleKeys.close.localize,
                      style: Styles.headerText(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      onPressed: () => context.pop()),
                ),
              ],
            )
          ]),
    );
  }
}
