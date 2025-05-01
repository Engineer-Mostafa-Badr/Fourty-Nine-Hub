import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialWidget extends StatelessWidget {
  final String icon;
  final int backGroundColor;
  final Color? color;
  final void Function()? onTap;
  const SocialWidget({
    super.key,
    required this.icon,
    required this.backGroundColor,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Color(backGroundColor),
        child: SvgPicture.asset(
          color: color,
          icon,
        ),
      ),
    );
  }
}
