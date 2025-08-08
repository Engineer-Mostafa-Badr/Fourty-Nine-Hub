import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/extensions/context_extension.dart';
import '../../../../../../../core/utils/hex_color_helper.dart';

import '../../../../../../../res/assets/assets.dart';
import '../../../../../../settings/presentation/pages/widgets/custombutton.dart';
import '../../../../../../../helpers/manage_vibration.dart';

class UsersWidget extends StatelessWidget {
  const UsersWidget({
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
            radius: 25,
            backgroundImage: AssetImage(Assets.userEx),
          ),
          const SizedBox(width: 10),
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
                Text(
                  context.isArabic ? 'عبد الرحمن_لطفي' : 'abdelrahman__lotafy',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w500,
                    color: context.isDarkMode ? Colors.white : Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      context.isArabic ? '3.2متابعين' : '3.2m followers',
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: context.isDarkMode ? Colors.white : Colors.grey,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      context.isArabic ? '7.9مشاهدات' : '7.9M Views',
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
          CustomButton(
            onPressed: () {

      ManageVibration.vibrate();
            },
            color: HexColor('F33D49'),
            textStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            text: context.isArabic ? 'متابعة' : 'Follow',
            width: 80,
            height: 40,
          ),
        ],
      ),
    );
  }
}