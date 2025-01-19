import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../res/style/app_colors.dart';
import '../../res/style/styles.dart';
import '../../routes/routes.dart';
import '../localization/locale_keys.g.dart';

class CustomTextNoLogin extends StatelessWidget {
  const CustomTextNoLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => context.push(Routes.LOGIN),
          child: Container(
            padding: EdgeInsets.all(12.w),
            width: 500.w,
            height: 500.h,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 4,
              ),
            ),
            child: Center(
              child: Text(
                'Please Login, Register to enjoy the app',
                style: Styles.headerText(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class CustomTextNoLoginNew extends StatelessWidget {
   CustomTextNoLoginNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => context.push(Routes.LOGIN),
          child: Center(
            child: Text(
              // 'Please Login,\n Register to enjoy the app',
              // 'تسجيل/تسجيل الدخول\n للاستمتاع بالتطبيق',
              // 'Register/Login \n To enjoy App',
              LocaleKeys.loginOrRegister.localize,
              style: Styles.headerText(
                fontSize: 50,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomNotLogged extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return   Stack(
      alignment: Alignment.center,
      children: [
        const CircularStepProgressIndicator(
          totalSteps: 20,
          stepSize: 20,
          selectedStepSize: 20,
          currentStep: 15,
          width: 300,
          height: 300,
          padding: 0.5,
          selectedColor: AppColors.PRIMARY_COLOR,
          unselectedColor: Colors.grey,
        ),
        CustomTextNoLoginNew()
      ],
    );
  }
}
