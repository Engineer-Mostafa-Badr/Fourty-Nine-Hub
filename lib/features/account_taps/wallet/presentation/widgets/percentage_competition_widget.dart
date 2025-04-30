import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../res/style/app_colors.dart';

class PercentageCompetitionWidget extends StatefulWidget {
  const PercentageCompetitionWidget({
    super.key,
    required this.currentPoints,
    required this.price,
    required this.currency,
    required this.totalPoints,
    required this.percentage,
  });

  final num price;
  final String currency;
  final int totalPoints;
  final num currentPoints;
  final double percentage;

  @override
  State<PercentageCompetitionWidget> createState() =>
      _PercentageCompetitionWidgetState();
}

class _PercentageCompetitionWidgetState
    extends State<PercentageCompetitionWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Positioned(
        // top: 50-24,
        // left: 70,
        // right: 70,
        // child:
        SizedBox(
          height: 180.w,
          child: Align(
            alignment: Alignment.center,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 350.w,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(1.00, 0.00),
                  end: const Alignment(-1, 0),
                  stops: widget.percentage > 100 ? [1] : null,
                  colors: widget.percentage > 100
                      ? [const Color(0xFFF33D49)]
                      : [
                          AppColors.PRIMARY_COLOR,
                          const Color(0xFF151F68),
                          const Color(0xFF202E9B),
                          AppColors.PRIMARY_COLOR
                        ],
                ),
              ),
              child: Center(
                child: Label(
                  text:
                      '${FormatNumbers().formatNumber(widget.currentPoints)} / ${FormatNumbers().formatNumber(widget.totalPoints)}',
                  style: Styles.headerText(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
          ),
        ),
        // ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 180.w,
                height: 180.w,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xFFF33D49),
                      AppColors.PRIMARY_COLOR,
                    ],
                    stops: [
                      widget.percentage / 100,
                      widget.percentage / 100,
                    ],
                    begin: AlignmentDirectional.centerStart,
                    end: AlignmentDirectional.centerEnd,
                  ),
                  shape: const OvalBorder(),
                ),
                child: Center(
                  child: Label(
                    text:
                        '${FormatNumbers().formatNumber(widget.price)} ${widget.currency}',
                    style: Styles.headerText(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
              const Sizer(),
              Label(
                text: LocaleKeys.getMoney.localize,
                //'Money Get',
                style: Styles.mediumText(fontSize: 20),
              ),
            ],
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 180.w,
                height: 180.w,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xFFF33D49),
                      AppColors.PRIMARY_COLOR,
                    ],
                    stops: [widget.percentage / 100, widget.percentage / 100],
                    begin: AlignmentDirectional.centerEnd,
                    end: AlignmentDirectional.centerStart,
                  ),
                  shape: const OvalBorder(),
                ),
                child: Center(
                  child: Label(
                    text: '${widget.percentage.toStringAsFixed(2)}%',
                    style: Styles.headerText(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
              const Sizer(),
              Label(
                text: LocaleKeys.withdrawalLimit.localize,
                style: Styles.mediumText(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
