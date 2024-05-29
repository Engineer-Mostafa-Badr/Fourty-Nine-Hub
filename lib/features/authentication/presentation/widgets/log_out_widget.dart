import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Label(
          text: 'Logout',
          style: Styles.headerText(),
        ),
        Label(
          text: 'Are you sure you want to logout?',
          style: Styles.mediumText(),
        ),
        const Sizer(),
        Row(
          children: [
            Expanded(
                child: AppButton(
              label: 'No',
              onPressed: () {},
              backColor: AppColors.DARK_GRAY_COLOR,
            )),
            const Sizer(),
            Expanded(child: AppButton(label: 'Logout', onPressed: () {})),
          ],
        )
      ],
    );
  }
}
