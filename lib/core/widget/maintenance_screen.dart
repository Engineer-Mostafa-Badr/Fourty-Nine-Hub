import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:lottie/lottie.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Lottie Animation - Under Construction
                SizedBox(
                  width: 500.w,
                  height: 450.h,
                  child: Lottie.asset(
                    'assets/json/under_construction.json',
                    fit: BoxFit.contain,
                  ),
                ),

                // SizedBox(height: 40.h),

                // Title
                Text(
                  context.isArabic
                      ? 'سوف نعود قريبا !'
                      : 'We\'ll be right back !',
                  style: Styles.headerText(
                    color: isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Subtitle
                Text(
                  context.isArabic
                      ? 'نحن نعمل على إصلاح التطبيق قريبًا'
                      : 'Our app is currently undergoing scheduled maintenance',
                  style: Styles.mediumText(
                    color:
                        isDarkMode ? Colors.white70 : AppColors.GREY_DARK_COLOR,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Info Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF2A2A2A)
                        : AppColors.PRIMARY_COLOR.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.PRIMARY_COLOR.withOpacity(0.3)
                          : AppColors.PRIMARY_COLOR.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.PRIMARY_COLOR,
                        size: 64,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        context.isArabic
                            ? 'ما الذي يحدث؟'
                            : 'What\'s happening?',
                        style: Styles.mediumText(
                          color: isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR,
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.isArabic
                            ? 'نحن نعمل على إصلاح التطبيق قريبًا'
                            : 'We\'re performing important updates to improve your experience. This won\'t take long!',
                        style: Styles.mediumText(
                          color: isDarkMode
                              ? Colors.white60
                              : AppColors.GREY_DARK_COLOR,
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  context.isArabic
                      ? 'يرجى التحقق مرة أخرى قريبا'
                      : 'Please check back in a few moments',
                  style: Styles.mediumText(
                    color:
                        isDarkMode ? Colors.white54 : AppColors.GREY_DARK_COLOR,
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(flex: 3),

                // Footer
                Column(
                  children: [
                    Text(
                      context.isArabic
                          ? 'شكراً لك على الإنتظار'
                          : 'Thank you for your patience',
                      style: Styles.mediumText(
                        color: isDarkMode
                            ? Colors.white38
                            : AppColors.GREY_DARK_COLOR,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '© 49 HUB FOR PROGRAMMING',
                      style: Styles.mediumText(
                        color: isDarkMode
                            ? Colors.white38
                            : AppColors.GREY_DARK_COLOR,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
