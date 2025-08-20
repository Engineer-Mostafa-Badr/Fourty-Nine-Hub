import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import '../../../../res/style/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../res/style/styles.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class CounterMoneyWidget extends StatefulWidget {
  const CounterMoneyWidget({super.key});

  @override
  _CounterMoneyWidgetState createState() => _CounterMoneyWidgetState();
}

class _CounterMoneyWidgetState extends State<CounterMoneyWidget> {
  int value = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
      ManageVibration.vibrate();
            setState(() {
              if (value > 0) {
                value = value - 1;
              }
            });
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 20.h,
            ),
            backgroundColor: AppColors.PRIMARY_COLOR,
          ),
          child: const Icon(
            Icons.remove,
            color: Colors.white,
          ),
        ),
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
          child: Center(
            child: Text(
              '$value',
              style: Styles.mediumText(
                color: Colors.white,
                fontSize: 80.sp,
              ),
            ),
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
      ManageVibration.vibrate();
            setState(() {
              value = value + 1; // زيادة القيمة
            });
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 20.h,
            ),
            backgroundColor: AppColors.PRIMARY_COLOR,
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}