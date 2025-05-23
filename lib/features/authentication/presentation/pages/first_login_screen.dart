import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class FirstLoginScreen extends StatelessWidget {
  const FirstLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Image.asset(Assets.logo,width: 100.w,height: 100.h,),
            const Spacer(),
            SvgPicture.asset(Assets.welcomeLogin,height: 200,),
            const Spacer(),
            Label(
              text: 'LocaleKeys.welcome.localize',
              style: Styles.headerText(
                color: context.isDarkMode
                    ? AppColors.AUTH_CONTAINER_COLOR
                    : AppColors.PRIMARY_COLOR,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * .4,
              height: 64,
              child: DefaultButton(
                width: double.infinity,
                label: LocaleKeys.login.localize,
                labelStyle: TextStyle(
                    fontSize: 32.sp,
                    color: AppColors.AUTH_CONTAINER_COLOR),
                onPressed: () {
                 context.go(Routes.LOGIN);
                },
              ),
            ),
            Sizer(height: 24,),
            SizedBox(
              height: 64,
              width: MediaQuery.sizeOf(context).width * .4,
              child: DefaultButton(
                width: double.infinity,
                label: LocaleKeys.register.localize,
                labelStyle: TextStyle(
                    fontSize: 35.sp,
                    color: AppColors.AUTH_CONTAINER_COLOR),
                onPressed: () {
                 context.go(Routes.REGISTER);
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
