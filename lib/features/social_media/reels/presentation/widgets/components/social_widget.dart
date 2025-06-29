import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialWidget extends StatelessWidget {
  final String icon;
  final int backGroundColor;
  final Color? color;
  final String? iconName;
  final double? radius;
  final double? width;

  final void Function()? onTap;
  const SocialWidget({
    super.key,
    required this.icon,
    required this.backGroundColor,
    this.color,
    this.onTap,
    this.iconName,
    this.radius,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
              radius: radius,
              backgroundColor: Color(backGroundColor),
              child: SvgPicture.asset(
                color: color,
                icon,
                width: width,
              )),
          Text(
            iconName ?? "",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
