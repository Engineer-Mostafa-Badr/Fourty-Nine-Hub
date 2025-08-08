import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/utils/hex_color_helper.dart';
import '../../../../../res/assets/assets.dart';

class SoundWidget extends StatelessWidget {
  const SoundWidget({
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10), // الحواف المستديرة
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  Assets.songEx,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 70.sp,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.isArabic
                      ? 'الصوت الأصلي - xrvvuib'
                      : 'Original Sound - xrvvuib',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.isArabic ? 'راف' : 'RAV',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: context.isDarkMode ? Colors.white : Colors.grey,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(
                      context.isArabic ? '00:30' : '00:30',
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: context.isDarkMode ? Colors.white : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      context.isArabic ? '7.9M فيديو' : ' 7.9M Videos',
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
          SizedBox(width: 12.w),
          Container(
            width: 120.w,
            height: 48.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: HexColor('F33D49'),
            ),
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
