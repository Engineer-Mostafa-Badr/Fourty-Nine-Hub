import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../res/style/app_colors.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton(
      {super.key, required this.onPressed, this.icon, this.text});

  final void Function() onPressed;
  final IconData? icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    // return FloatingActionButton(onPressed: onPressed);
    return SizedBox(
      width: MediaQuery.sizeOf(context).width*.4, // عرض الزر الجديد
      height: 56, // ارتفاع الزر الجديد
      child: RawMaterialButton(
        onPressed: onPressed,
        fillColor: AppColors.PRIMARY_COLOR,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              28), // نصف القطر لجعل الشكل دائريًا جزئيًا
        ),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: Colors.white, size: 24),
              if (icon != null) const SizedBox(width: 8),
              if (text != null)
                Text(
                  text??'',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14, // حجم النص أكبر قليلاً
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
