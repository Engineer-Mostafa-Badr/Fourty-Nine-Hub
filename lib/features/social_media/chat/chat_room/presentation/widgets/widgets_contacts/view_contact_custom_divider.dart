import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class ViewContactCustomDivider extends StatelessWidget {
  const ViewContactCustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.GRAY_LIGHT_COLOR3,
      height: 30,
      thickness: 8,
    );
  }
}
