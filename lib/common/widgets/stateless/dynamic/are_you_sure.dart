import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/custom_show_dialog.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

showAreYouSure({
  required String title,
  required String subTitle,
  required Function action,
  required BuildContext context,
}) {
  showAnimatedDialog(
    context,
    AlertDialog(
      content: AreYouSure(
        title: title,
        subTitle: subTitle,
        action: action,
      ),
    ),
  );
  // bottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     widget: AreYouSure(
  //       title: title,
  //       subTitle: subTitle,
  //       action: action,
  //     ));
}

class AreYouSure extends StatelessWidget {
  final String title, subTitle;
  final Function action;

  const AreYouSure(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.action});

  @override
  Widget build(BuildContext context) {
    return Column(
        // shrinkWrap: true,
      mainAxisSize: MainAxisSize.min,
        children: [
      Label(
        text: title,
        style: Styles.headerText().copyWith(color: AppColors.SECONDARY_COLOR),
      ),
      const Sizer(),
      Label(
        text: subTitle,
        maxLines: 2,
        style: Styles.mediumText(),
      ),
      const Sizer(),
      Row(
        children: [
          Expanded(
              child: AppButton(
                  color: AppColors.AUTH_CONTAINER_COLOR,
                  label: LocaleKeys.ok.localize,
                  onPressed: () {
                    action();
                    context.pop();
                  })),
          const Sizer(),
          Expanded(
              child: AppButton(
                  color: AppColors.QUANTITY_COLOR,
                  backColor: AppColors.LIGHT_GRAY_COLOR,
                  label: LocaleKeys.close.localize,
                  onPressed: () => context.pop())),
        ],
      )
    ]);
  }
}
