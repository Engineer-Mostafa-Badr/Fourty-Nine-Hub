import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../res/style/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../res/style/styles.dart';
class CounterMoneyWidget extends StatelessWidget {
  const CounterMoneyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding:  EdgeInsets.symmetric(
                horizontal: 15.w, vertical: 20.h,
              ),
              backgroundColor: AppColors.PRIMARY_COLOR,
            ),
            child: Icon(
              Icons.remove,
              color: Theme.of(context).scaffoldBackgroundColor,
            )),
        const Spacer(),
        Container(
          width: context.screenWidth / 1.7,
          height: 70.h,
          padding:
          EdgeInsets.only(top: 3.h, bottom: 3.h, left: 2.w, right: 25.w),
          decoration: BoxDecoration(
            color: AppColors.PRIMARY_COLOR,
            borderRadius: BorderRadius.circular(10),
          ),
          child:  Center(
            child: Text('0',
                style: Styles.mediumText(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: 80.sp,
                )),
          ),
        ),
        const Spacer(),
        ElevatedButton(
            onPressed: () {
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding:  EdgeInsets.symmetric(
                horizontal: 15.w, vertical: 20.h,
              ),
              backgroundColor: AppColors.PRIMARY_COLOR,
            ),
            child: Icon(
              Icons.add,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
        )
      ],
    );
  }
}

