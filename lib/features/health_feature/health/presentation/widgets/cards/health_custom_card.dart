import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class HealthCustomCard extends StatelessWidget {
  const HealthCustomCard({
    super.key,
    required this.children,
    this.title = '',  this.padding, this.margin, this.radiusGeometry,
  });
  final List<Widget> children;
  final String title;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? radiusGeometry;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:margin??EdgeInsets.zero ,
      width: double.infinity,
      padding: padding??EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.getButtonPrimaryWhiteColor(context),
        ),
        borderRadius: radiusGeometry,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          )
        ],
      ),
    );
  }
}
