import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Sizer extends StatelessWidget {
  final double? height;
  final double? width;

  const Sizer({
    super.key,
    this.height = 15,
    this.width = 15,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height?.h,
      width: width?.w,
    );
  }
}
