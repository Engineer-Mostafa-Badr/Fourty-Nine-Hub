import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class ConfirmHeader extends StatelessWidget {
  const ConfirmHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35.w),
      child: Row(
        children: [
          Text(
            "Confirmation".localize,
            style: Styles.headerText(
                fontSize: 40, color: AppColors.black),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
