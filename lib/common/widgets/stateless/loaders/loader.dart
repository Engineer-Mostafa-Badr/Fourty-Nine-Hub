import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:lottie/lottie.dart';


class Loader {
  /// default dialog loaders
  static DDLoader({required BuildContext context}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
            child: Lottie.asset(Assets.circleLoader, height: 30.h));
      },
    );
  }
/// simple default loaders
  static Widget DLoader() {
    return Center(child: Lottie.asset(Assets.circleLoader, width: 100.w));
  }



}
