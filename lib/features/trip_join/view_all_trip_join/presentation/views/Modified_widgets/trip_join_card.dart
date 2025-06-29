import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.children,
    this.title = '', this.radius=10,
    this.padding,
    this.color,
  });
  final List<Widget> children;
  final String title;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: context.isDarkMode
              ? AppColors.whiteColor
              : AppColors.PRIMARY_COLOR_LIGHT,
        ),
        borderRadius: BorderRadius.circular(radius),
        color: color ?? Theme.of(context).scaffoldBackgroundColor,
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
