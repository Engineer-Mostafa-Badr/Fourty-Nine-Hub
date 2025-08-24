import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../res/style/app_colors.dart';

class PrivacyMessageWidget extends StatelessWidget {
  const PrivacyMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(
            Icons.lock,
            size: 16.sp,
            color: Colors.grey.shade600,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black87,
                ),
                children: [
                  const TextSpan(text: 'Your personal messages are '),
                  TextSpan(
                    text: 'Block contact, disappearing messages',
                    style: TextStyle(
                      color: AppColors.PRIMARY_COLOR,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
