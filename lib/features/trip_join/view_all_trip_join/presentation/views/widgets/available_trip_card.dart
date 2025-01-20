import 'package:easy_localization/easy_localization.dart' as EasyLocale;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:intl/intl.dart' as intl;

class AvailableTripCard extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const AvailableTripCard({
    super.key,
    required this.tripJoinCardEntity,
    this.premuimRequestOnTap,
    this.requestOnTap,
    this.callOnTap,
    this.messageOnTap,
    this.reportOnTap,
    this.subscribeMessageOnTap,
  });
  final TripJoinCardEntity tripJoinCardEntity;

  final void Function()? premuimRequestOnTap;
  final void Function()? requestOnTap;
  final void Function()? callOnTap;
  final void Function()? messageOnTap;
  final void Function()? reportOnTap;
  final void Function()? subscribeMessageOnTap;

  @override
  State<AvailableTripCard> createState() => _AvailableTripCardState();
}

class _AvailableTripCardState extends State<AvailableTripCard> {
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
                  Row(crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _localizeStatus(
                            context, widget.tripJoinCardEntity.status ?? ''),
                        style: Styles.headerText(
                          fontSize: 30,
                          color: AppColors.getSecondryColor(context),
                        ),
                      ),
                      const Spacer(),


                      Row(crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              widget.tripJoinCardEntity.journeyPrice
                                      ?.toStringAsFixed(0) ??
                                  '' "  ",
                              style: Styles.headerText(
                                  fontSize: 50, color:Colors.black
                              // Colors.green[600]
                              )
                          ),
                          const SizedBox(width: 2,),
                          context.locale.languageCode=="ar"?
                          Text(
                            context.isArabic
                                ? BlocProvider.of<GetCurrencyCubit>(context)
                                    .currnecyAr
                                : BlocProvider.of<GetCurrencyCubit>(context)
                                    .currnecyEn,
                            style: Styles.mediumText(fontSize:context.locale.languageCode=="ar"?35: 30,
                                fontWeight: FontWeight.w500,
                                color:AppColors.SECONDARY_COLOR
                            ),
                          )
                              :SizedBox(height: 17,
                            child:  Text(
                            context.isArabic
                                ? BlocProvider.of<GetCurrencyCubit>(context)
                                .currnecyAr
                                : BlocProvider.of<GetCurrencyCubit>(context)
                                .currnecyEn,
                            style: Styles.mediumText(fontSize:context.locale.languageCode=="ar"?35: 30,
                                fontWeight: FontWeight.w500,
                                color:AppColors.SECONDARY_COLOR
                            ),
                          ),)
                        ],
                      ),
                    ],
                  ),
                  widget.tripJoinCardEntity.brand!=null&&widget.tripJoinCardEntity.brand!=""?
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.time_to_leave),
                      const Sizer(),
                      Text(
                        '${widget.tripJoinCardEntity.brand}, ${widget.tripJoinCardEntity.model}',
                        style: Styles.headerText(
                          fontSize: 45,
                          color: AppColors.getSecondryColor(context),
                          // color: testColor,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ):const SizedBox.shrink(),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.airline_seat_recline_extra_rounded),
                      const Sizer(),
                      Text(' ${widget.tripJoinCardEntity.seatNumber ?? 1} ',
                          style: Styles.headerText()),
                      Text(LocaleKeys.seat.localize,
                          style: Styles.headerText()),
                      const Spacer(),
                      Visibility(
                        visible: widget.tripJoinCardEntity.isRepeated ?? false,
                        child: Icon(
                          (widget.tripJoinCardEntity.isRepeated ?? false)
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                      const Sizer(),
                      Visibility(
                        visible: widget.tripJoinCardEntity.isRepeated ?? false,
                        child: Text(LocaleKeys.repeat.localize,
                            style: Styles.headerText()),
                      ),
                      const Sizer(width: 20),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.trip_origin,
                          color: AppColors.LIGHT_BLUE, size: 20),
                      const Sizer(width: 13),
                      Flexible(
                        child: Text(
                          context.isArabic
                              ? widget.tripJoinCardEntity.startingAddressAr ??
                                  ''
                              : widget.tripJoinCardEntity.startingAddressEn ??
                                  '',
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
                              ? widget.tripJoinCardEntity
                                      .destinationAddressAr ??
                                  ''
                              : widget.tripJoinCardEntity
                                      .destinationAddressEn ??
                                  '',
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
                          onTap: widget.premuimRequestOnTap,
                        ),
                      ),
                      const Sizer(width: 5),
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: LocaleKeys.regularRequest.localize,
                          color: AppColors.PRIMARY_COLOR,
                          onTap: widget.requestOnTap,
                        ),
                      )
                    ],
                  ),
                  const Sizer(),
                  CallMessageButtons(
                    otherUserId: widget.tripJoinCardEntity.userId!,
                    subcategoryId: widget.tripJoinCardEntity.categoryId!,
                    phone: widget.tripJoinCardEntity.phone!,
                    id: widget.tripJoinCardEntity.id!,
                    hasReport: true,
                  ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     Expanded(
                  //       flex: 3,
                  //       child: AvaialbleTripsButton(
                  //         title: LocaleKeys.call.localize,
                  //         color: (widget.tripJoinCardEntity.isApproved ?? false)
                  //             ? AppColors.PRIMARY_COLOR
                  //             : AppColors.DARK_GRAY_COLOR,
                  //         icon: Icons.call,
                  //         onTap: widget.callOnTap,
                  //       ),
                  //     ),
                  //     const Sizer(width: 5),
                  //     Expanded(
                  //       flex: 3,
                  //       child: AvaialbleTripsButton(
                  //         title: LocaleKeys.message.localize,
                  //         color: (widget.tripJoinCardEntity.isApproved ?? false)
                  //             ? AppColors.PRIMARY_COLOR
                  //             : AppColors.DARK_GRAY_COLOR,
                  //         icon: Icons.email,
                  //         onTap: widget.messageOnTap,
                  //       ),
                  //     ),
                  //     const Sizer(width: 5),
                  //     Expanded(
                  //       flex: 3,
                  //       child: AvaialbleTripsButton(
                  //         title: LocaleKeys.report.localize,
                  //         // color: testColor,
                  //         color: AppColors.getSecondryColor(context),
                  //         icon: Icons.report,
                  //         onTap: widget.reportOnTap,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ],
          ),
          const Sizer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: widget.subscribeMessageOnTap,
              child: Text(
                LocaleKeys.subscribeToContactClient.localize,
                style: Styles.headerText(
                  color: AppColors.getSecondryColor(context),
                  fontSize: 30,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          )
        ],
      ),
    );
  }

  String _formatDate(BuildContext context) {
    if (widget.tripJoinCardEntity.publishDate == null) {
      return '';
    }
    return intl.DateFormat('dd MMM, hh:mm aaa', context.locale.languageCode)
        .format(DateTime.fromMicrosecondsSinceEpoch(
            widget.tripJoinCardEntity.publishDate! * 1000000));
  }

  String _localizeStatus(BuildContext context, String text) {
    switch (text.toLowerCase().trim()) {
      case 'premium':
        return context.isArabic ? 'مميز' : 'Premium';
      default:
        return context.isArabic ? 'عادي' : 'Regular';
    }
  }
}
