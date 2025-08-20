import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../common/widgets/stateless/labels/label.dart';

class SubscribeButton extends StatelessWidget {
  final String text;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onShowHint;
  final double? width;
  final double? height;
  final Color? selectedColor;
  final Color? unselectedColor;
  final TextStyle? textStyle;

  const SubscribeButton({
    super.key,
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.onShowHint,
    this.width,
    this.height,
    this.selectedColor,
    this.unselectedColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: width ?? 160.w,
            height: height ?? 50.h,
            decoration: BoxDecoration(
              color: isSelected
                  ? (selectedColor ?? const Color(0XFFF88B92))
                  : (unselectedColor ?? Colors.white),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Label(
              text: text,
              textAlign: TextAlign.center,
              style: textStyle ??
                  TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.black : const Color(0xff727272),
                  ),
            ),
          ),
        ),
        Positioned(
          top: -14,
          right: -6,
          child: GestureDetector(
            onTap: onShowHint,
            child: SvgPicture.asset(icon),
          ),
        ),
      ],
    );
  }
}