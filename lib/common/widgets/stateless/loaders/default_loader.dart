import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../res/assets/assets.dart';

class DLoader extends StatelessWidget {
  const DLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return   Center(child: Lottie.asset(Assets.circleLoader, width: 150.w));
  }
}
