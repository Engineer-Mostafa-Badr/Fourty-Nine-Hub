import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/utils/hex_color_helper.dart';
import '../../../../../res/assets/assets.dart';

class PlacesWidget extends StatelessWidget {
  const PlacesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: HexColor('ECECEC'),
            ),
            child: Center(child: SvgPicture.asset(Assets.placeIcon)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.isArabic ? 'فيجما' : 'Figma',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      context.isArabic ? 'مطعم سريع' : 'Fast Food Restaurant',
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: context.isDarkMode ? Colors.white : Colors.grey,
                      ),
                    ),
                    Text(
                      context.isArabic ? '. 180.4K فيديو' : '. 180.4K videos',
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: context.isDarkMode ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.isArabic
                          ? 'باغتيم، شبرا الخيمة'
                          : 'Bahtim, Shubra El Kheima...',
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: context.isDarkMode ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
