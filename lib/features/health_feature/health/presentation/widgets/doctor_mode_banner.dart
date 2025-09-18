import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorModeBanner extends StatelessWidget {
  const DoctorModeBanner({
    super.key,
    required this.isApproval,
  });
  final bool isApproval;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          height: 64.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(2, 4),
                blurRadius: 6,
              ),
            ],
            gradient: LinearGradient(
              colors: [isApproval?AppColors.SECONDARY_COLOR_DARK2:AppColors.GREY_DARK_COLOR, AppColors.c90242B],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                context.isArabic ? 'وضع الطبيب' : 'Doctor Mode',
                style: Styles.mediumText(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),

      ],
    );
  }
}
