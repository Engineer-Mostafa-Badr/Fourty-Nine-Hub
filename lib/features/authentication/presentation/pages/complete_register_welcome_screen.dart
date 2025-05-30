import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/buttons/default_button.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';

class CompleteRegisterWelcomeScreen extends StatelessWidget {
  const CompleteRegisterWelcomeScreen(
      {super.key, required this.giftMessageEntity});

  final String giftMessageEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(flex: 2,),
          Expanded(
            flex: 5,
            child: Image.asset(
              context.isDarkMode ? Assets.logo : Assets.logoWithBlackText,
            ),
          ),
          const Spacer(flex: 2,),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: context.isDarkMode
                    ? AppColors.whiteColor
                    : AppColors.PRIMARY_COLOR,
                width: context.isDarkMode ? 2 : 0,
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              // margin: const EdgeInsets.symmetric(horizontal: 16),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                Assets.loginGIF,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Spacer(flex: 2,),
          Text(
            LocaleKeys.congratulations.localize,
            style: Styles.headerText(
              color: AppColors.SECONDARY_COLOR,
            ),
          ),
          const Spacer(),
          Text(
            giftMessageEntity,
            textAlign: TextAlign.center,
            style: Styles.mediumText(),
          ),
          const Spacer(flex: 2,),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * .4,
            height: 50,
            child: DefaultButton(
              backgroundColor: context.isDarkMode
                  ? AppColors.whiteColor
                  : AppColors.PRIMARY_COLOR,
              width: double.infinity,
              label: LocaleKeys.next.localize,
              labelStyle: TextStyle(
                fontSize: 32.sp,
                color: context.isDarkMode
                    ? AppColors.PRIMARY_COLOR
                    : AppColors.AUTH_CONTAINER_COLOR,
              ),
              onPressed: () {
                context.go(Routes.HOME);
              },
            ),
          ),
          const Spacer(flex: 2,),
        ],
      ),
    );
  }
}
