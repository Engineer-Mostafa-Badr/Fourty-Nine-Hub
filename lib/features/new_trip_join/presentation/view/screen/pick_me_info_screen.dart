import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../core/utils/handle_cashback.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import '../../../captainshare/screen/captain_share_info_screen.dart';

class PickMeInfoScreen extends StatefulWidget {
  const PickMeInfoScreen({super.key});

  @override
  State<PickMeInfoScreen> createState() => _PickMeInfoScreenState();
}

class _PickMeInfoScreenState extends State<PickMeInfoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          context.push(Routes.pickMeInfoScreen);
        },
        child: Container(
          width: 300.w,
          height: 80.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: AppColors.PRIMARY_COLOR,
          ),
          child: Center(
            child: Text(
              context.isArabic ? "بدء الرحلة!" : "Start Journey!",
              style: TextStyle(
                fontSize: 32.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: HomeAppbar(
          isWithBackArrow: false,
          language: true,
          leading: IconButton(
            icon: const Icon(Icons.menu), // The menu icon
            onPressed: () {
              HandleCashback.setCount('drawerCount', context);
              _scaffoldKey.currentState?.openDrawer(); // Open the drawer
            },
          ),
        ),
      ),
      body: const PickMeInfoInfoBody(),
    );
  }
}

class PickMeInfoInfoBody extends StatelessWidget {
  const PickMeInfoInfoBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.h),
          Text(
            context.isArabic ? "وصلني معاك!" : 'Pick me!',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
            ),
          ),
          SizedBox(height: 20.h),
          SvgPicture.asset(Assets.pickMeInfoIcon),
          SizedBox(height: 30.h),
          RowTextWidget(
            text: context.isArabic ? "لا تملك سيارة؟!" : "Don't have a car?!",
          ),
          SizedBox(height: 15.h),
          RowTextWidget(
            text: context.isArabic
                ? " تعبت من السعر الباهظ."
                : 'Tired from the expensive price.',
          ),
          SizedBox(height: 15.h),
          RowTextWidget(
            text: context.isArabic
                ? "قم بالإعلان عن رحلتك المتكررة يوميًا."
                : 'Advertise your daily repeat trip.',
          ),
          SizedBox(height: 15.h),
          RowTextWidget(
            text: context.isArabic
                ? "انتظر حتى يتصل بك أصحاب السيارات."
                : 'Wait for car owners to contact you.',
          ),
          SizedBox(height: 15.h),
          RowTextWidget(
              text: context.isArabic
                  ? "شارك رحلتك ووفر المال."
                  : 'Share your trip & save money.'),
        ],
      ),
    );
  }
}
