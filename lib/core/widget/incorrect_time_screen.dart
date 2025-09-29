import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class IncorrectTimeScreen extends StatelessWidget {
  const IncorrectTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // العنوان
                const Text(
                  'تاريخ / وقت غير صحيح',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 40),

                // الأيقونة
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(
                    Icons.access_time,
                    size: 48,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 40),

                // النص التوضيحي
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'تاريخ ووقت جهازك غير مضبوط.\nمن فضلك قم بتصحيحه من الإعدادات.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
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
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'ضبط الوقت',
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
