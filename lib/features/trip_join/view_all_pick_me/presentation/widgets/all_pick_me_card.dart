import 'package:easy_localization/easy_localization.dart' as easyLocale;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/domain/entities/pickme_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:intl/intl.dart' as intl;

class AllPickMeCard extends StatelessWidget {
  const AllPickMeCard({
    super.key,
    required this.pickMeCardEntity,
    this.premuimRequestOnTap,
    this.requestOnTap,
    this.callOnTap,
    this.messageOnTap,
    this.reportOnTap,
    this.subscribeMessageOnTap,
  });
  final PickMeCardEntity pickMeCardEntity;
  final void Function()? premuimRequestOnTap;
  final void Function()? requestOnTap;
  final void Function()? callOnTap;
  final void Function()? messageOnTap;
  final void Function()? reportOnTap;
  final void Function()? subscribeMessageOnTap;
  @override
  Widget build(BuildContext context) {
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
                      Container(
                        width: 150.w,
                        height: 150.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[300]!,
                                offset: const Offset(3, 3)),
                          ],
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          pickMeCardEntity.gender == 'female'
                              ? Assets.femaleImagePlacehlder
                              : Assets.maleImagePlaceholder,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Sizer(width: 30.w),
                      Text(pickMeCardEntity.firstName ?? 'Unknown',
                          style: Styles.headerText()),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_month),
                      const Sizer(),
                      Text(_formatDate(context), style: Styles.headerText()),
                    ],
                  ),
                  const Sizer(),
                  Visibility(
                    visible: pickMeCardEntity.isRepeated ?? false,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          (pickMeCardEntity.isRepeated ?? false)
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                        Text(LocaleKeys.repeat.localize,
                            style: Styles.headerText()),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: pickMeCardEntity.isRepeated ?? false,
                    child: const Sizer(),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.trip_origin,
                          color: AppColors.LIGHT_BLUE, size: 20),
                      const Sizer(width: 13),
                      Flexible(
                        child: Text(
                          context.isArabic
                              ? pickMeCardEntity.startingAddressAr ?? ''
                              : pickMeCardEntity.startingAddressEn ?? '',
                          style: Styles.headerText(fontSize: 32),
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
                      const Icon(Icons.trip_origin,
                          color: AppColors.CHECK_MARK_COLOR, size: 20),
                      const Sizer(width: 13),
                      Flexible(
                        child: Text(
                          context.isArabic
                              ? pickMeCardEntity.destinationAddressAr ?? ''
                              : pickMeCardEntity.destinationAddressEn ?? '',
                          style: Styles.headerText(fontSize: 32),
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
                        child: AvaialbleTripsButton(
                          title: LocaleKeys.premuimRequest.localize,
                          // color: testColor,
                          color: AppColors.getSecondryColor(context),
                          onTap: premuimRequestOnTap,
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
                  const Sizer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: LocaleKeys.call.localize,
                          color: (pickMeCardEntity.isApproved ?? false)
                              ? AppColors.PRIMARY_COLOR
                              : AppColors.DARK_GRAY_COLOR,
                          icon: Icons.call,
                          onTap: callOnTap,
                        ),
                      ),
                      const Sizer(width: 5),
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: LocaleKeys.message.localize,
                          color: (pickMeCardEntity.isApproved ?? false)
                              ? AppColors.PRIMARY_COLOR
                              : AppColors.DARK_GRAY_COLOR,
                          icon: Icons.email,
                          onTap: messageOnTap,
                        ),
                      ),
                      const Sizer(width: 5),
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: LocaleKeys.report.localize,
                          // color: testColor,
                          color: AppColors.getSecondryColor(context),
                          icon: Icons.report,
                          onTap: reportOnTap,
                        ),
                      ),
                    ],
                  ),

                  // RequestButton
                  //  CallMessageButtons(
                  //       otherUserId: widget.item.userId,
                  //       subcategoryId: widget.item.subCategoryId,
                  //       phone: widget.item.phone,
                  //       id: widget.item.id,
                  //       hasReport: true,
                  //     ),
                  //d
                  const Sizer(),
                ],
              ),
              Positioned.directional(
                top: 5,
                end: 20,
                textDirection:
                    context.isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                            pickMeCardEntity.journeyPrice?.toStringAsFixed(0) ??
                                '',
                            style: Styles.headerText(
                                fontSize: 70, color: Colors.green[600])),
                        Text(
                          context.isArabic
                              ? BlocProvider.of<GetCurrencyCubit>(context)
                                  .currnecyAr
                              : BlocProvider.of<GetCurrencyCubit>(context)
                                  .currnecyEn,
                          style: Styles.mediumText(
                              fontWeight: FontWeight.bold,
                              color: AppColors.SECONDARY_COLOR),
                        )
                      ],
                    ),
                    Text(
                      _localizeStatus(context, pickMeCardEntity.status ?? ''),
                      style: Styles.headerText(
                        fontSize: 30,
                        color: AppColors.getSecondryColor(context),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Sizer(),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context) {
    if (pickMeCardEntity.publishDate == null) {
      return '';
    }
    return intl.DateFormat('dd MMM, hh:mm aaa', context.locale.languageCode)
        .format(DateTime.fromMicrosecondsSinceEpoch(
            pickMeCardEntity.publishDate! * 1000000));
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
