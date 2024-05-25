import 'package:flutter/material.dart';

import '../../../res/style/app_colors.dart';

class GoogleAddsBanner extends StatelessWidget {
  const GoogleAddsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: AppColors.GRAY_LIGHT_COLOR3,
              blurRadius: 5,
              spreadRadius: 5,
            )
          ]),
      child: const Center(
        child: Text('Google Adds'),
      ),
    );
  }
}
