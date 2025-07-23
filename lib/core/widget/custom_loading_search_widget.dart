import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../res/assets/assets.dart';

class CustomLoadingSearchWidget extends StatelessWidget {
  const CustomLoadingSearchWidget({
    super.key,
    this.message = 'جاري البحث...',
    this.size = 120,
    this.showMessage = true,
  });

  final String message;
  final double size;
  final bool showMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              Assets.searchLoading,
              height: size.h,
              width: size.w,
              fit: BoxFit.contain,
              repeat: true,
              frameRate: FrameRate.max,
            ),
            if (showMessage) ...[
              SizedBox(height: 12.h),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 16.sp,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
