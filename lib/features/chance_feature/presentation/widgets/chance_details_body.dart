import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../res/style/styles.dart';
import '../widgets/card_details_widget_of_details_view.dart';
import '../widgets/counter_money_widget.dart';
import '../widgets/subscribe_button_widget.dart';

class ChanceDetailsBody extends StatelessWidget {
  const ChanceDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CardDetails(),
        SizedBox(height: 20.h),
        SizedBox(height: 10.h),
        Text(
            'Type the value you want to participation',
            style: Styles.mediumText(
              color: Theme.of(context).primaryColor,
              fontSize: 50.sp,

            )),
        SizedBox(height: 15.h),
        const CounterMoneyWidget(),
        SizedBox(height: 80.h),
        const SubscribeButtonWidget(),
      ],
    );
  }
}
