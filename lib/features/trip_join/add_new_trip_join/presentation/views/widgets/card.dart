import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.children,
    this.title = '',
  });
  final List<Widget> children;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.isDarkMode
              ? AppColors.PRIMARY_COLOR_DARK
              : AppColors.PRIMARY_COLOR_LIGHT,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: context.isDarkMode
                ? AppColors.PRIMARY_COLOR_DARK.withOpacity(0.5)
                : AppColors.PRIMARY_COLOR_LIGHT.withOpacity(0.5),
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          )
        ],
      ),
    );
  }
}
