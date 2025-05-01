import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class IconAndTextWidget extends StatelessWidget {
  final String name;
  final String icon;
  const IconAndTextWidget({
    super.key,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset(icon),
          SizedBox(width: 10.w),
          Text(
            name,
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
