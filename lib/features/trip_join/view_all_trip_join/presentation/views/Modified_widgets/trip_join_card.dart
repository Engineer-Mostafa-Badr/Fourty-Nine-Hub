import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.children,
    this.title = '', this.radius=10,  this.padding,
  });
  final List<Widget> children;
  final String title;
  final double radius;
  final EdgeInsetsGeometry? padding;
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
        borderRadius: BorderRadius.circular(radius),
        color: Theme.of(context).scaffoldBackgroundColor,
        // boxShadow: [
        //   BoxShadow(
        //     color: context.isDarkMode
        //         ? AppColors.PRIMARY_COLOR_DARK.withOpacity(0.5)
        //         : AppColors.PRIMARY_COLOR_LIGHT.withOpacity(0.5),
        //     offset: const Offset(1, 2),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          )
        ],
      ),
    );
  }
}
