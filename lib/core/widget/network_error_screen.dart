import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/service/connectivity_service.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Network error icon
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY_COLOR.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    size: 60.sp,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                ),
                SizedBox(height: 32.h),
                
                // Title
                Text(
                  LocaleKeys.noInternetConnection.tr(),
                  style: Styles.headerText(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                
                // Description
                Text(
                  LocaleKeys.checkInternetConnection.tr(),
                  style: Styles.mediumText(
                    fontSize: 16.sp,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                
                // Retry button
                ElevatedButton.icon(
                  onPressed: () {
                    // Trigger network check by refreshing the NetworkManager
                    NetworkManager().initialize();
                    // Also trigger a manual check
                    NetworkManager().checkActualInternetAccess();
                  },
                  icon: Icon(
                    Icons.refresh_rounded,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                  label: Text(
                    LocaleKeys.retry.tr(),
                    style: Styles.mediumText(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.PRIMARY_COLOR,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 16.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
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