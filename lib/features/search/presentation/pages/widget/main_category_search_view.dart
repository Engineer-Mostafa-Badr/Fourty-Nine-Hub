import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class MainCategorySearchView extends StatelessWidget {
  const MainCategorySearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 10.w),
      child: ListView.separated(
        itemBuilder: (context, index) => buildItem(),
        separatorBuilder: (context, index) => const Sizer(),
        itemCount: 10,
      ),
    );
  }

  Widget buildItem() => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 120.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: const NetworkImage(
                    'https://gratisography.com/wp-content/uploads/2024/01/gratisography-cyber-kitty-800x525.jpg'),
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Label(
            text: 'Craft',
            style: TextStyle(
                color: AppColors.AUTH_CONTAINER_COLOR,
                fontWeight: FontWeight.bold,
                fontSize: 45.sp),
          ),
          PositionedDirectional(
            start: 0.h,
            bottom: 0.h,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h, left: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    color: AppColors.SECONDARY_COLOR,
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border),
                  ),
                  Label(
                    text: '0 Ads',
                    style: Styles.mediumText(
                      fontWeight: FontWeight.bold,
                      color: AppColors.AUTH_CONTAINER_COLOR,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
