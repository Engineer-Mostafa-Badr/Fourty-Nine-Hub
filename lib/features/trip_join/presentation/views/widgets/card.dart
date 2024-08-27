import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.PRIMARY_COLOR),
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
