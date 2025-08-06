import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';

class PickUpContainer extends StatelessWidget {
  const PickUpContainer(
      {super.key, required this.title, this.fontWeight, this.fontSize});

  final String title;
  final FontWeight? fontWeight;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment:context.isArabic ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsetsDirectional.only(start: 16),
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Label(
          text: title,
          style: TextStyle(
              fontWeight: fontWeight ?? FontWeight.w400,
              fontSize: fontSize ?? 16,
          color:  AppColors.PRIMARY_COLOR
          ),
          textAlign: TextAlign.center,
        ));
  }
}

class PickUpContainerNonSocket extends StatelessWidget {
  const PickUpContainerNonSocket({
    super.key,
    required this.title,
    this.fontWeight,
    this.fontSize,
    required this.icon,
  });

  final String title;
  final FontWeight? fontWeight;
  final double? fontSize;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: context.isArabic ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8), // Add some spacing
            Expanded(
              child: Label(
                text: title,
                style: TextStyle(
                  fontWeight: fontWeight ?? FontWeight.w400,
                  fontSize: fontSize ?? 16,
                  color: AppColors.PRIMARY_COLOR,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


