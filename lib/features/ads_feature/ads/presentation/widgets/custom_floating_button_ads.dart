import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CustomFloatingButtonAds extends StatelessWidget {
  const CustomFloatingButtonAds({
    super.key,
    required this.title,
    required this.onPressed,
  });
  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        // height: 44,
        // constraints: BoxConstraints(
        //   minWidth: 120,
        // ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          color: AppColors.getButtonPrimaryColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Label(
          text: title,
          style: Styles.mediumText(
            color: AppColors.getReversedTextColor(context),
            fontWeight: FontWeight.w600,
            height: 1.60,
          ),
        ),
      ),
    );
  }
}
