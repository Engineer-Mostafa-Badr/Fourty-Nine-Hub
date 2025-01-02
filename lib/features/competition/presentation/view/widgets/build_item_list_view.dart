import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/competition/domain/entity/competition_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/currency_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/localization/locales.dart';
import '../../../../../res/style/styles.dart';
import 'donut_chart_painter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildItemListView extends StatelessWidget {
  const BuildItemListView(
      {super.key,
      required this.model,
      required this.icon,
      required this.currency});

  final CompetitionEntity model;
  final CurrencyEntity currency;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    num count = model.countOfRequest;
    num max = model.maxRequests;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                context.push(Routes.GIFT);
              },
              child: Text(
                context.locale == Locales.english ? model.nameEn : model.nameAr,
                style: Styles.headerText(),
              ),
            ),
          ],
        ),
        Sizer(
          height: 40.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 45.w, vertical: 20.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.push(Routes.GIFT);
                },
                child: CustomPaint(
                  size: const Size(20, 20),
                  painter: DonutChartPainter(
                      context: context,
                      count: count,
                      max: max,
                      title: context.locale == Locales.english
                          ? '${model.amount.toStringAsFixed(0)} ${context.locale == Locales.english ? currency.currencyEn : currency.currencyAr}'
                          : '${context.locale == Locales.english ? currency.currencyEn : currency.currencyAr} ${model.amount.toStringAsFixed(0)}'),
                ),
              ),
              SizedBox(width: 55.w),
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
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
              SizedBox(width: 10.w),
              Expanded(
                child: Container(
                 // height: 50,
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h,),
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
              SizedBox(width: 55.w),
              CustomPaint(
                size: const Size(20, 20),
                painter: DonutChartPainter(
                  context: context,
                  count: count,
                  max: max,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 25.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: GestureDetector(
            onTap: () {
              context.push(Routes.GIFT);
            },
            child: Text(
              context.locale == Locales.english
                  ? model.descriptionEn
                  : model.descriptionAr,
              style: Styles.mediumText(),
            ),
          ),
        ),
      ],
    );
  }
}
