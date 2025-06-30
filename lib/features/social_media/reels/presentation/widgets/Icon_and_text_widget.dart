import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

class IconAndTextWidget extends StatelessWidget {
  final String name;
  final String icon;
  final void Function()? onTap;
  const IconAndTextWidget({
    super.key,
    required this.name,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(width: 11),
            SvgPicture.asset(
              icon,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
            SizedBox(width: 4),
            Text(
              name,
              style: TextStyle(
                color: context.isDarkMode ? Colors.white : Colors.black,
                fontSize: 30.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
