import 'package:flutter/material.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../helpers/manage_vibration.dart';

class AvailableTripsFloatingActionButton extends StatelessWidget {
  const AvailableTripsFloatingActionButton({
    super.key,
  });

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
          onPressed: () {
      ManageVibration.vibrate();

          },
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
                  context.isArabic ? "أعلن عن سيارتك" : "Advertise your car",
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