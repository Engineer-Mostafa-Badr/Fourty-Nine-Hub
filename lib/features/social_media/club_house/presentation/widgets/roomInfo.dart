import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/widget/custom_switch_button.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../helpers/manage_vibration.dart';

class RoomInfoWidget extends StatelessWidget {
  const RoomInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 30.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  spreadRadius: 6,
                ),
              ],
            ),
            child: Row(
              children: [
                const ProfileImage(
                  accountId: 0,
                  userId: '',
                ),
                const Sizer(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Label(
                          text: 'Public',
                          style:
                              Styles.mediumText(fontWeight: FontWeight.bold)),
                      Label(
                          text: 'Anyone on 49 can join',
                          style: Styles.mediumText(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ],
            ),
          ),
          Sizer(
            height: 20.h,
          ),
          Container(
            height: 45.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xfff3f3f3),
            ),
            child: TextField(
              textAlignVertical: TextAlignVertical.bottom,
              style: TextStyle(color: Colors.black, fontSize: 12.sp),
              decoration: InputDecoration(
                hintText: 'Room title',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.sp),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xfff3f3f3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xfff3f3f3)),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 45.h,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xfff3f3f3),
            ),
            child: Row(
              children: [
                const Text(
                  'Allow Replays',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                CustomSwitchButton(
                  value: true,
                  // activeColor: AppColors.PRIMARY_COLOR,
                  onChanged: (v) {},
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 45.h,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xfff3f3f3),
            ),
            child: Row(
              children: [
                const Text(
                  'Allow room chat',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                CustomSwitchButton(
                  value: true,
                  // activeColor: AppColors.PRIMARY_COLOR,
                  onChanged: (v) {},
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xfff3f3f3),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: const Row(
                    children: [
                      Text(
                        'Pinned link',
                        style: TextStyle(),
                      ),
                      Spacer(),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
                const Divider(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: const Row(
                    children: [
                      Text(
                        'Topics',
                        style: TextStyle(),
                      ),
                      Spacer(),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
                const Divider(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: const Row(
                    children: [
                      Text(
                        'Language',
                        style: TextStyle(),
                      ),
                      Spacer(),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
                const Divider(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: const Row(
                    children: [
                      Text(
                        'Hand Raising',
                        style: TextStyle(),
                      ),
                      Spacer(),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          InkWell(
            onTap: () {
      ManageVibration.vibrate();
              context.push(Routes.CLUBHOUSECHAT);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'Start new Room',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}