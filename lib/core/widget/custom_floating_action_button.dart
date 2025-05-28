import 'package:flutter/material.dart';

import '../../res/style/app_colors.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton(
      {super.key,
      required this.onPressed,
      this.icon,
      this.text,
      this.fontSize,
      this.iconSize});

  final void Function() onPressed;
  final IconData? icon;
  final String? text;
  final double? fontSize;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    // return FloatingActionButton(onPressed: onPressed);
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * .4,
      // height: 56,
      child: RawMaterialButton(
        onPressed: onPressed,
        fillColor: AppColors.getButtonPrimaryColor(context),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(28), // نصف القطر لجعل الشكل دائريًا جزئيًا
        ),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: AppColors.getReversedTextColor(context), size:iconSize?? 24),
              if (icon != null) const SizedBox(width: 8),
              if (text != null)
                Text(
                  text ?? '',
                  style: TextStyle(
                    color: AppColors.getReversedTextColor(context),
                    fontSize: fontSize ?? 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
