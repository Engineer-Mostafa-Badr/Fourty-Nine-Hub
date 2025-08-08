import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/extensions/context_extension.dart';

class SoundOptionBottomSheet extends StatelessWidget {
  const SoundOptionBottomSheet({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  final String icon;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        icon,
        color: context.isDarkMode ? Colors.white : Colors.black,
        width: 30.w,
        height: 40.h,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 32.sp,
        ),
      ),
      onTap: onTap,
    );
  }
}
