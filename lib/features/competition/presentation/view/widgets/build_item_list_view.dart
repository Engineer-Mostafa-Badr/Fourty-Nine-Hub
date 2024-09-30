import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/competition/data/models/competion_model.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/localization/locales.dart';
import '../../../../../res/style/styles.dart';
import 'donut_chart_painter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildItemListView extends StatelessWidget {
  BuildItemListView({super.key, required this.model, required this.icon});

  final CompetitionData model;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    int count = model.countOfRequest!;
    int max = model
        .competitionId?.maxRequests  ??0;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.locale == Locales.english
                  ? model.competitionId?.nameEn ??''
                  : model.competitionId?.nameAr ??'',
              style: Styles.headerText(),
            ),
            // const Spacer(),
            // Padding(
            //   padding: EdgeInsets.all(8.0.w),
            //   child: Icon(icon, color: Colors.grey, size: 50.sp),
            // ),
          ],
        ),
         const Sizer(),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    '${LocaleKeys.count.localize}$count',
                    style: Styles.mediumText(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5.w), // Adjust spacing between containers
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    '${LocaleKeys.max.localize}$max',
                    style: Styles.mediumText(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ),
              ),
            ),
            SizedBox(width: 40.w), // Adjust spacing between containers
            CustomPaint(
              size: const Size(20, 20), // Adjust the size as needed
              painter: DonutChartPainter(
                context: context,
                count: count,
                max: max,
              ),
            ),
            SizedBox(width: 50.w),
          ],
        ),
        SizedBox(
          height: 20.h, // Space between the text and the row
        ),
        Padding(
          padding:  EdgeInsets.only(left: 5.w),
          child: Text(
            context.locale == Locales.english
                ? model.competitionId?.descriptionEn ??''
                : model.competitionId?.descriptionAr ??'',
            style: Styles.mediumText(),
          ),
        ),
      ],
    );
  }
}
