import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../res/assets/assets.dart';

class TripOptionWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;
  final Color? containerColor;
  final Color? borderColor;

  const TripOptionWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    this.onTap,
    this.iconColor,
    this.textColor,
    this.containerColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(height: 30.h),
          Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                imagePath,
                colorFilter: iconColor != null
                    ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                    : null,
              ),
              Positioned(
                top: 13.h,
                child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: containerColor ?? const Color(0xFFBFC1C8), //
                      border: Border.all(
                        color: borderColor ?? const Color(0xFF2A5082),
                        width: 5.w,
                      ),
                    ),
                    child: Image.asset(Assets.pickMeIcon)),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          SvgPicture.asset(Assets.shadowTripIcon),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
