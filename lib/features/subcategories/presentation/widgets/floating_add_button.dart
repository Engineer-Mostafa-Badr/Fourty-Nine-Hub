import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:popover/popover.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

Widget buildFloatingAction(BuildContext context,Function()onTap){
  return FloatingActionButton.extended(
    onPressed: () {
      onTap();
    },
    backgroundColor: AppColors.PRIMARY_COLOR,
    icon: const Icon(
      Icons.add,
      color: Colors.white,
    ),
    label: Label(
      text: LocaleKeys.addAde.localize,
      style: Styles.mediumText(
          fontWeight: FontWeight.bold,color: Colors.white),
    ),
  );
}

