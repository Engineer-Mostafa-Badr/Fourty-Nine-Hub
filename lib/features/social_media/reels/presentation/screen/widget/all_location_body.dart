import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/video_card_widget.dart';

import '../../../../../../res/assets/assets.dart';

class AllLocationBody extends StatelessWidget {
  const AllLocationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.isArabic ? 'مصر الجديدة' : 'Masr Al Jadidah',
                style: TextStyle(
                  fontSize: 48.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                width: 130,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffF33D49),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.saveSongIcon,
                      color: Colors.white,
                      width: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      context.isArabic ? 'المفضلة' : 'Favorite',
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            context.isArabic ? 'القاهرة' : 'Cairo, Egypt',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w500,
              color: context.isDarkMode ? Colors.white : Colors.grey,
            ),
          ),
          SizedBox(height: 24.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.isArabic ? 'المنشورات من الاخرين' : 'Posts from others',
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w700,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 24.h),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 8,
                  childAspectRatio: 9 / 20,
                ),
                itemBuilder: (context, index) => VideoCardWidget(
                  videoUrl:
                      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
                  play: false,
                ),
                itemCount: 4,
              ),
            ],
          )
        ],
      ),
    );
  }
}
