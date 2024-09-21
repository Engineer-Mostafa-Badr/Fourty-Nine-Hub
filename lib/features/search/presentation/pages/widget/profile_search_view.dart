import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class ProfileSearchView extends StatelessWidget {
  const ProfileSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 30.w),
      child: ListView.separated(
        itemBuilder: (context, index) => buildItem(),
        separatorBuilder: (context, index) => Divider(
          color: AppColors.GREY_LIGHT_COLOR,
          indent: 20.w,
        ),
        itemCount: 10,
      ),
    );
  }

  Widget buildItem() => Row(
        children: [
          Container(
            height: 65.h,
            width: 65.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://gratisography.com/wp-content/uploads/2024/01/gratisography-cyber-kitty-800x525.jpg'),
              ),
            ),
          ),
          const Sizer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Label(text: 'Moaz Mohamed'),
               Label(
                text: 'Friend',
                style: Styles.smallText(
                  color: AppColors.GREY_NORMAL_COLOR,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward,
            color: AppColors.GREY_NORMAL_COLOR,
          )
        ],
      );
}
