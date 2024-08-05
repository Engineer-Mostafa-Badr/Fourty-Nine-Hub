import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/doctor_chart.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorHistoryCard extends StatelessWidget {
  final String title;
  final num totalValue;
  final double clinicValue;
  final double callValue;
  final double homeVisitValue;
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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
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
                  style: Styles.headerText(
                    color: AppColors.PRIMARY_COLOR,
                  ),
                ),
              ),
              const Sizer(
                width: 20,
              ),
              Label(
                text: (totalValue).toShortScale,
                style: Styles.headerText(
                  color: AppColors.SECONDARY_COLOR,
                ),
              ),
            ],
          ),
          const Sizer(
            height: 60,
          ),
          DoctorHistoryChart(
            clinicValue: clinicValue,
            callValue: callValue,
            homeVisitValue: homeVisitValue,
          ),
        ],
      ),
    );
  }
}
