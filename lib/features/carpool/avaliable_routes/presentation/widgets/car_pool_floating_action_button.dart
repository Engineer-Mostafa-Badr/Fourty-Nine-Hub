import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class CarpoolFloatingActionButton extends StatelessWidget {
  const CarpoolFloatingActionButton({
    super.key,
    required this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned.directional(
      bottom: 10,
      end: 10,
      textDirection: context.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: SizedBox(
        // width: 120, // عرض الزر الجديد
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
                const Icon(Icons.add, color: Colors.white, size: 24),
                const SizedBox(width: 8), // مسافة بين الأيقونة والنص
                Text(
                  context.isArabic ? "إنشاء طريق جديد" : "Create a new route",
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
      ),
    );
  }
}
