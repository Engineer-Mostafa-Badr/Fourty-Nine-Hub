import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    this.height = double.infinity,
    this.title = 'Find',
  });
  final void Function()? onTap;
  final double height;
  final String title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.PRIMARY_COLOR.withOpacity(0.6),
      radius: 45,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.PRIMARY_COLOR.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.PRIMARY_COLOR,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: Styles.headerText(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
