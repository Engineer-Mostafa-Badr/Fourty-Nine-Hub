import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class IncorrectTimeScreen extends StatelessWidget {
  const IncorrectTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 50),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // العنوان
              Text(
                  context.isArabic?"تاريخ / وقت غير صحيح":"Date / Time is incorrect",
                  style: TextStyle(
                    color: AppColors.PRIMARY_COLOR,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 40),

                // الأيقونة
                Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.PRIMARY_COLOR.withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.access_time,
                        size: 48,
                        color: AppColors.SECONDARY_COLOR,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // النص التوضيحي
                                Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                       context.isArabic?"تاريخ ووقت جهازك غير مضبوط.\nمن فضلك قم بتصحيحه من الإعدادات.":"Your device date/time is incorrect.\nPlease update it in system settings.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.PRIMARY_COLOR,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // زر الفتح
                ElevatedButton(
                  onPressed: () {
                    AppSettings.openAppSettings(
                      type: AppSettingsType.date
                    ); // Opens general app settings
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.SECONDARY_COLOR,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    context.isArabic?"ضبط الوقت":"Update Time",
                    style: TextStyle(fontSize: 16),
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
