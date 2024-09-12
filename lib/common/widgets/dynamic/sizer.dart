import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class Sizer extends StatelessWidget {
  final double? height;
  final double? width;

  Sizer({
    super.key,
    this.height = 10,
    this.width = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
