import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:lottie/lottie.dart';

import '../widget/custom_circular_progress_indicator.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key, this.searchLoading = false});
  final bool searchLoading;

  @override
  Widget build(BuildContext context) {
    if (searchLoading) {
      return Lottie.asset(Assets.searchLoading);
    }
    return const Center(child: CustomCircularProgressIndicator());
  }
}
