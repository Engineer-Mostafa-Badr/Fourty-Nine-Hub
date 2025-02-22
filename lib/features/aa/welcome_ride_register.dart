import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../res/assets/assets.dart';
import '../../res/style/styles.dart';
import '../../routes/routes.dart';

class WelcomeRideRegister extends StatelessWidget {
  const WelcomeRideRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const HomeAppbar(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 60.h,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.GREY_LIGHT_COLOR,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.PRIMARY_COLOR,
            ),
          ),
          const Sizer(),
          InkWell(
            onTap: ()=> context.push(Routes.personalInformationScreen),
            child: Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Label(
                    text: LocaleKeys.next,
                    style: Styles.headerText(
                      fontWeight: FontWeight.w400,
                      color: AppColors.AUTH_CONTAINER_COLOR,
                    ),
                  ),
                  Sizer(),
                  Sizer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.AUTH_CONTAINER_COLOR,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              text: 'Welcome to Ride Register',
              style: Styles.headerText(
                  fontWeight: FontWeight.w500,
                  color: AppColors.SECONDARY_COLOR),
            ),
            Sizer(),
            Sizer(),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.3,
                mainAxisSpacing: 32.w,
                crossAxisSpacing: 32.h,
                children: List.generate(
                  14,
                  (index) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color:index==100? AppColors.GREY_LIGHT_COLOR:Colors.transparent
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.rideIcon,
                          width: 80.w,
                        ),
                        const Sizer(),
                        Label(
                          text: 'Captain',
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
