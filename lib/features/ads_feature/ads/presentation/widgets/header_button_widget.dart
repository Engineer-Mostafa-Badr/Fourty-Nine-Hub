import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class HeaderButtonWidget extends StatelessWidget {
  const HeaderButtonWidget({
    super.key,
    required this.title,
    required this.onPressed,
    required this.isOpened,
  });

  final String title;
  final void Function() onPressed;
  final bool isOpened;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        // width: double.infinity,
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: ShapeDecoration(
          color: isOpened ? AppColors.getButtonPrimaryColor(context) : AppColors.getFillColor(context),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isOpened ? AppColors.cF33D49 :AppColors.getButtonPrimaryColor(context),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: Styles.headerText(
              fontSize: 22,
              color: isOpened ? AppColors.getReversedTextColor(context) : AppColors.getTextColor(context),
            ),
          ),
        ),
      ),
    );
  }
}
