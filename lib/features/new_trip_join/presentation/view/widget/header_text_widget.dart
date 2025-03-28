import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderTextWidget extends StatelessWidget {
  const HeaderTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "One Way - One Captain!",
      style: TextStyle(
        color: const Color(0xffFF0808),
        fontWeight: FontWeight.bold,
        fontSize: 30.sp,
      ),
    );
  }
}
