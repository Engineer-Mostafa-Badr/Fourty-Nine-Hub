import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../../core/utils/hex_color_helper.dart';

class HashtagsWidget extends StatelessWidget {
  const HashtagsWidget({
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
          CircleAvatar(
            backgroundColor: HexColor('ECECEC'),
            radius: 25,
            child: SvgPicture.asset(Assets.hashtagsIcon),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.isArabic
                      ? 'ترندات تيك توك جديد'
                      : 'New TikTok trends',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Text(
                      context.isArabic ? '7.9M منشورات' : '7.9M Posts',
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: context.isDarkMode ? Colors.white : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 120.w,
            height: 48.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: HexColor(
                  'F33D49',
                )),
            child: Center(
              child: SvgPicture.asset(
                Assets.addSoundIcon,
                width: 30.w,
                height: 30.h,
              ),
            ),
          )
        ],
      ),
    );
  }
}
