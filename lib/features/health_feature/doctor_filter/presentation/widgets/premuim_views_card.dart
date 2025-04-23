import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class PremuimViewsCard extends StatelessWidget {
  const PremuimViewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Icon(
          Icons.remove_red_eye_rounded,
          color: AppColors.grey,
        ),
        Sizer(
          width: 10,
        ),
        Label(text: "4372 Views"),
        Spacer(),
        Label(
          text: LocaleKeys.notSubscribed.localize,
          style: Styles.mediumText(color: AppColors.colorRed,fontWeight: FontWeight.w600),
        ),
        Sizer()
      ],
    );
  }
}
