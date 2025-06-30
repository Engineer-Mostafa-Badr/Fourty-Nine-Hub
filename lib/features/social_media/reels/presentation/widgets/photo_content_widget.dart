import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../res/assets/assets.dart';

class PhotoContentWidget extends StatelessWidget {
  const PhotoContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          childAspectRatio: 9 / 12,
        ),
        itemBuilder: (context, index) => PhotoWidget(),
        itemCount: 6,
      ),
    );
  }
}

class PhotoWidget extends StatelessWidget {
  const PhotoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: 170,
          height: 175,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            image: DecorationImage(
              image: AssetImage(Assets.photoEx),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              context.isArabic ? '2 ابريل 2023' : 'Apr 2, 2023',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage(Assets.userEx),
            ),
            const SizedBox(width: 5),
            Text(
              context.isArabic ? 'عبد الرحمن_لطفي' : 'Usef Elshazly',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
                color: context.isDarkMode ? Colors.white : Color(0XFF7C7C7C),
              ),
            ),
            SizedBox(width: 15),
            Icon(
              Icons.favorite_border,
              color: context.isDarkMode ? Colors.white : Colors.grey,
              size: 40.sp,
            ),
            SizedBox(width: 5),
            Text(
              '1067',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: context.isDarkMode ? Colors.white : Colors.grey,
              ),
            ),
          ],
        )
      ],
    );
  }
}
