import 'package:flutter/material.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../../res/assets/assets.dart';

Widget uploadFileWidget({required String title}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.GREYBG,
        ),
        height: 100,
        width: 100,
        padding: const EdgeInsets.all(35),
        child:  Image.asset(
          Assets.uploadImageCamera,
          height: 30,
          width: 30,
          color: AppColors.PRIMARY_COLOR,
        ),
      ),
      const Sizer(),
      Label(
        text: title,
        style: Styles.smallText(
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
        overflow: TextOverflow.visible,
        maxLines: 3,
        textAlign: TextAlign.center,
      ),
    ],
  );
}
