import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/charts/bar_chart.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/earned_mony_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorHistoryCard extends StatelessWidget {
  final List<EarnedMoneyEntity> totalEarnedMoney;
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
      required this.homeVisitValue,
      required this.totalEarnedMoney});

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
              const Sizer(
                width: 20,
              ),
              Label(
                text: title == 'Total Appointments'
                    ? totalEarnedMoney
                        .fold(0, (sum, element) => sum + element.count.toInt())
                        .toString()
                    : totalEarnedMoney
                        .fold(0,
                            (sum, element) => sum + element.totalEarned.toInt())
                        .toString(),
                style: Styles.headerText(),
              ),
            ],
          ),
          Sizer(
            height: 30.h,
          ),
          CustomBarChart(
            data: [
              if (totalEarnedMoney
                  .any((element) => element.appointmentType == 'clinic'))
                BarData(
                  label: Labels.clinic,
                  value: title == 'Total Appointments'
                      ? totalEarnedMoney
                          .where(
                              (element) => element.appointmentType == 'clinic')
                          .fold(0, (sum, element) => sum + element.count)
                      : totalEarnedMoney
                          .where(
                              (element) => element.appointmentType == 'clinic')
                          .fold(0, (sum, element) => sum + element.totalEarned),
                ),
              if (totalEarnedMoney
                  .any((element) => element.appointmentType == 'calls'))
                BarData(
                  label: Labels.call,
                  value: title == 'Total Appointments'
                      ? totalEarnedMoney
                          .where(
                              (element) => element.appointmentType == 'calls')
                          .fold(0, (sum, element) => sum + element.count)
                      : totalEarnedMoney
                          .where(
                              (element) => element.appointmentType == 'calls')
                          .fold(0, (sum, element) => sum + element.totalEarned),
                ),
              if (totalEarnedMoney
                  .any((element) => element.appointmentType == 'homevisit'))
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
