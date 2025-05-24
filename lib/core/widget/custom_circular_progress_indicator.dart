import 'package:flutter/material.dart';

import '../../res/style/app_colors.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({super.key, this.value});

  final double? value;
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: AppColors.getButtonPrimaryWhiteColor(context),
      value: value,
    );
  }
}
