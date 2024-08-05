import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorHistoryChart extends StatelessWidget {
  final double clinicValue;
  final double callValue;
  final double homeVisitValue;
  const DoctorHistoryChart(
      {super.key,
      required this.clinicValue,
      required this.callValue,
      required this.homeVisitValue});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
            barGroups: [
              getBar(1, clinicValue),
              getBar(2, callValue),
              getBar(3, homeVisitValue),
            ],
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: titlesData,
            barTouchData: barTouchData),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.toShortScale,
              const TextStyle(
                color: AppColors.PRIMARY_COLOR,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  BarChartGroupData getBar(int x, double y) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: [0],
      barRods: [
        BarChartRodData(
            toY: y,
            width: 20,
            gradient: const LinearGradient(
              colors: [
                AppColors.PRIMARY_COLOR,
                AppColors.SECONDARY_COLOR,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )),
      ],
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );
  Widget getTitles(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 1:
        text = Labels.clinic;
        break;
      case 2:
        text = Labels.call;
        break;
      case 3:
        text = Labels.homeVist;
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: Styles.mediumText()),
    );
  }
}
