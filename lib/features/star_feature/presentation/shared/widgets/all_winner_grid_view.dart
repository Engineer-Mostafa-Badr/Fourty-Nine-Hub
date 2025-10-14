import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/localization/locales.dart';
import '../../../../../core/utils/duration_helper.dart';
import '../../../../../res/assets/assets.dart';
import '../../../domain/entity/star_winner_entity.dart';
import '../../presentation_exports.dart';

class AllWinnerGridView extends StatelessWidget {
  final List<StarWinnerEntity>? winner;
  final StarCubit starCubit;
  const AllWinnerGridView({super.key, this.winner, required this.starCubit});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.w,
        childAspectRatio: 1.12.h,
      ),
      itemBuilder: (context, index) {
        // if (index == starCubit.winners.length) {
        //   return const Center(child: CustomCircularProgressIndicator());
        // }
        return _buildWinnerCard(winner![index]);
      },
      itemCount: winner?.length ?? 0,
    );
  }

  Widget _buildWinnerCard(StarWinnerEntity star) {
    return Builder(
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          decoration: BoxDecoration(
            color: context.isDarkMode
                ? const Color(0xB3FFFFFF)
                : const Color(0xB3000000),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 70.r,
                    backgroundImage: Image.network(
                      star.user.image,
                      height: 100.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ).image,
                  ),
                  Positioned(
                    top: -32,
                    right: -14,
                    child: Image.asset(
                      Assets.crown,
                      height: 100.h,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(
                      "${star.user.firstName} ${star.user.lastName}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 26.sp,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${star.user.viewNumber.toShortScale.toArabicNumbers(context)} ${LocaleKeys.views.localize} ",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "${LocaleKeys.winner_rating.localize} ${star.user.averageRating.toShortScale.toArabicNumbers(context)} ",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Image.asset(
                          Assets.starGold,
                          height: 20.h,
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      DurationHelper()
                          .getTimeDifference(DateTime.parse(star.createdAt!))
                          .localize
                          .toArabicNumbers(context),
                      style: TextStyle(
                        fontSize: 28.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${star.profit.toShortScale.toArabicNumbers(context)} ${LocaleKeys.egp.localize}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 26.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatDateInWinners(String date, BuildContext context) {
    DateTime parsedDate = DateTime.parse(date);

    return context.locale == Locales.english
        ? DateFormat('d/M/yyyy', 'en').format(parsedDate)
        : DateFormat('yyyy/M/d', 'ar').format(parsedDate);
  }
}
