import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

void showAreYouSure({
  required String title,
  required String subTitle,
  required Function action,
  required BuildContext context,
}) {
  bottomSheet(
      isScrollControlled: true,
      context: context,
      widget: AreYouSure(
        title: title,
        subTitle: subTitle,
        action: action,
      ));
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
    return ListView(shrinkWrap: true, children: [
      Label(
        text: title,
        style: Styles.headerText(),
      ),
      const Sizer(),
      Label(
        text: subTitle,
        style: Styles.mediumText(),
      ),
      const Sizer(),
      Row(
        children: [
          Expanded(child: AppButton(label: 'Ok', onPressed: () => action())),
          const Sizer(),
          Expanded(
              child: AppButton(
                  backColor: AppColors.LIGHT_GRAY_COLOR,
                  label: 'Close',
                  onPressed: () => context.pop())),
        ],
      )
    ]);
  }
}
