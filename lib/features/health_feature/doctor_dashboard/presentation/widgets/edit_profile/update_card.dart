import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditDoctorProfileCard extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final TextStyle? textStyle;
  final IconData? icon;
  final Color? iconColor;
  const EditDoctorProfileCard(
      {super.key,
      required this.title,
      this.onTap,
      this.textStyle,
      this.icon,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Label(
              text: title,
              style: textStyle ?? Styles.headerText(),
            ),
            const Spacer(),
            Icon(
              icon ?? Icons.edit,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
