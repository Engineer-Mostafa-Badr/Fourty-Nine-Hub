import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../helpers/manage_vibration.dart';
import '../../../../../res/assets/assets.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class TripOptionWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;
  final Color? containerColor;
  final Color? borderColor;
  final String? icon;

  const TripOptionWidget({
    super.key,
    required this.imagePath,
    required this.title,
    this.onTap,
    this.iconColor,
    this.textColor,
    this.containerColor,
    this.borderColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        onTap?.call();
        },
      child: Column(
        children: [
          SizedBox(height: 8.h),
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
                    child: Image.asset(
                      icon ?? Assets.pickMeIcon,
                    )),
              ),
            ],
          ),
          SvgPicture.asset(
            Assets.shadowTripIcon,
            color: context.isDarkMode ? const Color(0xFF333333) : null,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: Styles.mediumText(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}