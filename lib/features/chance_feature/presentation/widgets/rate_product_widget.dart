import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../res/style/app_colors.dart';

class LinerProgressIndicator extends StatelessWidget {
  const LinerProgressIndicator({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LinearProgressIndicator(
          value: 0.65,
          color: AppColors.SECONDARY_COLOR,
          backgroundColor: Colors.grey.shade300,
        ),
      ),
    );
  }
}
