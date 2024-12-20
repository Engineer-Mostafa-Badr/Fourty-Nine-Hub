import 'package:easy_localization/easy_localization.dart' as EasyLocale;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/premium_request_button.dart';
import 'package:fourtyninehub/features/search/domain/entity/trip_come_with_you_entity.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:intl/intl.dart' as intl;

class BuildItemTripCome extends StatelessWidget {
  const BuildItemTripCome({
    super.key,
    required this.tripJoinCardEntity,
    this.subscribeMessageOnTap,
    this.requestOnTap,
  });
  final TripComeWithYouEntity tripJoinCardEntity;
  final void Function()? requestOnTap;
  final void Function()? subscribeMessageOnTap;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdvertisementCubit>(
      create: (BuildContext context) => serviceLocator(),
      child: BlocBuilder<AdvertisementCubit, AdsState>(
        builder: (BuildContext context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CustomCard(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.time_to_leave),
                            const Sizer(),
                            Text(
                              '${tripJoinCardEntity.vehicleBrand}, ${tripJoinCardEntity.vehicleModel}',
                              style: Styles.headerText(
                                fontSize: 60.sp,
                                color: AppColors.getSecondryColor(context),
                                // color: testColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        const Sizer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.calendar_month),
                            const Sizer(),
                            Text(_formatDate(context),
                                style: Styles.headerText()),
                          ],
                        ),
                        const Sizer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                                Icons.airline_seat_recline_extra_rounded),
                            const Sizer(),
                            Text(' ${tripJoinCardEntity.passengers} ',
                                style: Styles.headerText()),
                            Text(LocaleKeys.seat.localize,
                                style: Styles.headerText()),
                            const Spacer(),
                            Visibility(
                              visible: tripJoinCardEntity.isRepeat,
                              child: Icon(
                                (tripJoinCardEntity.isRepeat)
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: AppColors.PRIMARY_COLOR,
                              ),
                            ),
                            const Sizer(),
                            Visibility(
                              visible: tripJoinCardEntity.isRepeat,
                              child: Text(LocaleKeys.repeat.localize,
                                  style: Styles.headerText()),
                            ),
                            Sizer(width: 40.w),
                          ],
                        ),
                        const Sizer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.trip_origin,
                                color: AppColors.LIGHT_BLUE, size: 35.sp),
                            Sizer(width: 25.w),
                            Flexible(
                              child: Text(
                                context.isArabic
                                    ? tripJoinCardEntity.fromAr
                                    : tripJoinCardEntity.fromEn,
                                style: Styles.headerText(fontSize: 60.sp),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        const Sizer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.trip_origin,
                                color: AppColors.CHECK_MARK_COLOR, size: 35.sp),
                            Sizer(width: 25.sp),
                            Flexible(
                              child: Text(
                                context.isArabic
                                    ? tripJoinCardEntity.toAr
                                    : tripJoinCardEntity.toEn,
                                style: Styles.headerText(fontSize: 60.sp),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        const Sizer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: PremiumRequestButton(
                                adId: tripJoinCardEntity.id,
                                subCategoryId: tripJoinCardEntity.categoryId,
                                subscriptionStatus: tripJoinCardEntity.status,
                                //  subscriptionStatus: widget.item.subscriptionStatus??'',
                              ),
                            ),
                            const Sizer(width: 5),
                            Expanded(
                              flex: 3,
                              child: AvaialbleTripsButton(
                                title: LocaleKeys.regularRequest.localize,
                                color: AppColors.PRIMARY_COLOR,
                                onTap: requestOnTap,
                              ),
                            )
                          ],
                        ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     Expanded(
                        //       flex: 3,
                        //       child: PremiumRequestButton(
                        //         adId: tripJoinCardEntity.id,
                        //         subCategoryId: tripJoinCardEntity.categoryId,
                        //         subscriptionStatus: tripJoinCardEntity.status,
                        //         //  subscriptionStatus: widget.item.subscriptionStatus??'',
                        //       ),
                        //     ),
                        //     Sizer(width: 10.w),
                        //     Expanded(
                        //       flex: 3,
                        //       child: RequestButton(
                        //         adId: tripJoinCardEntity.id,
                        //         subscriptionStatus: tripJoinCardEntity.status,
                        //         //subscriptionStatus: widget.item.subscriptionStatus??'',
                        //       ),
                        //     )
                        //   ],
                        // ),
                        const Sizer(),
                        CallMessageButtons(
                          otherUserId: tripJoinCardEntity.userId,
                          // subcategoryId: tripJoinCardEntity.subCategoryId,
                          subcategoryId: tripJoinCardEntity.categoryId,
                          phone: tripJoinCardEntity.phone,
                          id: tripJoinCardEntity.id,
                          hasReport: true,
                        ),
                      ],
                    ),
                    Positioned.directional(
                      top: 10.h,
                      end: 30.w,
                      textDirection: context.isArabic
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Column(
                        children: [
                          Text(tripJoinCardEntity.price.toStringAsFixed(0),
                              style: Styles.headerText(
                                  fontSize: 100.sp, color: Colors.green[600])),
                          Text(
                            _localizeStatus(context, tripJoinCardEntity.status),
                            style: Styles.headerText(
                              fontSize: 60.sp,
                              color: AppColors.getSecondryColor(context),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const Sizer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: InkWell(
                    onTap: subscribeMessageOnTap,
                    child: Text(
                      LocaleKeys.subscribeToContactClient.localize,
                      style: Styles.headerText(
                        color: AppColors.getSecondryColor(context),
                        fontSize: 60.sp,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(BuildContext context) {
    return intl.DateFormat('dd MMM, hh:mm aaa', context.locale.languageCode)
        .format(DateTime.fromMicrosecondsSinceEpoch(
            tripJoinCardEntity.time * 1000000));
  }

  String _localizeStatus(BuildContext context, String text) {
    switch (text.toLowerCase().trim()) {
      case 'regular':
        return context.isArabic ? 'عادي' : 'Regular';
      case 'premium':
        return context.isArabic ? 'مميز' : 'Premium';
      default:
        return text;
    }
  }
}
