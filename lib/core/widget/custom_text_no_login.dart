import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../res/style/styles.dart';
import '../../routes/routes.dart';

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
