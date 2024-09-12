import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/charts/bar_chart.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorHistoryCard extends StatelessWidget {
  final String title;
  final num totalValue;
  final num clinicValue;
  final num callValue;
  final num homeVisitValue;
  const DoctorHistoryCard(
      {super.key,
      required this.title,
      required this.totalValue,
      required this.clinicValue,
      required this.callValue,
      required this.homeVisitValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Label(
                  text: title,
                  style: Styles.headerText(),
                ),
              ),
              Sizer(
                width: 20,
              ),
              Label(
                text: (totalValue).toShortScale,
                style: Styles.headerText(),
              ),
            ],
          ),
          Sizer(
            height: 30.h,
          ),
          CustomBarChart(
            data: [
              BarData(
                label: Labels.clinic,
                value: clinicValue,
              ),
              BarData(
                label: Labels.call,
                value: callValue,
              ),
              BarData(
                label: Labels.homeVist,
                value: homeVisitValue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
