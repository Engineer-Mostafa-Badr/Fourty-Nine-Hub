import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/core/widget/common/global_card.dart';
import 'package:fourtyninehub/core/widget/common/profile_picture_widget.dart';
import 'package:fourtyninehub/core/widget/common/trip_location_widget.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../data/models/loading/get_loading_accepted_model.dart';
import '../../controllers/dashboards_cubit/dashboards_cubit.dart';
import 'loading_dashboard_details_screen.dart';

class AcceptedNonSocketLoadingWidget extends StatelessWidget {
  // final String modeType;
  final GetLoadingAcceptedEntity? offers;

  const AcceptedNonSocketLoadingWidget(
      {super.key,
      // this.modeType = 'truk',
      this.offers});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(
        offers?.tripDetails?.createdAt ?? '2025-03-11T21:50:21.998Z');
    String formattedDate =
        "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
    String formattedTime =
        "${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12} ${dateTime.hour < 12 ? 'AM' : 'PM'}";
    return BlocListener<DashboardsCubit, DashboardsState>(
      listener: (context, state) {
        if (state.status == DashboardsStates.error) {
          String errorName = getFailureName(state.failure!, context);
          final failure = state.failure;

          // if (failure is ServerFailure) {
          //   if (failure.errors != null && failure.errors!.isNotEmpty) {
          //     showErrorMessage(context, failure.errors!.first);
          //     return;
          //   }
          //
          //   if (errorName == 'DebtError') {
          //     showDebtDialog(context, offers?.subCategory?.id ?? "");
          //   } else if (errorName == 'SubscribeError') {
          //     showSubscribeDialog(context, offers?.subCategory?.id ?? "");
          //   }
          //   else {
          //     showErrorMessage(
          //         context, getFailureMessage(state.failure!, context));
          //   }
          //
          //   // Optional: After showing dialog, dispatch an event to clear the error
          //   // context.read<DashboardsCubit>().add(ClearErrorEvent());
          // }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: GlobalCard(
          hasBottomSide: true,
          otherUserId: '',
          phone: '',
          reportId: offers?.client?.id ?? '',
          subcategoryId: offers?.tripDetails?.category?.id ?? '',
          // isButtonEnabled: offers.,
          subCategoryTitle: context.isArabic
              ? offers?.tripDetails?.category?.nameAr ?? ''
              : offers?.tripDetails?.category?.nameEn ?? '',
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(children: [
                      Row(
                        children: [
                          ClickableWidget(
                            onTap: () {},
                            child: ProfilePictureWidget(
                              rating:
                                  (offers?.client?.rating?.averageRating ?? 0)
                                      .toInt(),
                              image: offers?.client?.profilePictureKey ?? '',
                              hasStories: false,
                            ),
                          ),
                          Sizer(),
                          Expanded(
                            child: Label(
                                text: offers?.client?.firstName ?? '',
                                style: Styles.mediumText()),
                          ),
                        ],
                      ),
                      Sizer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TripLocationWidget(
                              isFrom: true,
                              title: offers?.tripDetails?.location?.fromTitle ??
                                  'From Location',
                              fontSize: 28),
                          TripLocationWidget(
                              isFrom: false,
                              title: offers?.tripDetails?.location?.toTitle ??
                                  'Cairo International Airport',
                              fontSize: 28),
                        ],
                      ),
                      Label(
                        text:
                            "${context.isArabic ? "وصف الحمولة" : "Cargo Description"} : ${offers?.tripDetails?.cargoDescription ?? ''} ",
                        style: Styles.mediumText(),
                        maxLines: 2,
                      ),
                    ])),
                    const Sizer(width: 32),
                    Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     // Expanded(
                        //     //   flex: 7,
                        //     //   child: Column(
                        //     //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     //     children: [
                        //     //       TripLocationWidget(isFrom: true, title: offers?.tripDetails?.location
                        //     //           ?.fromTitle ??
                        //     //           'Cairo International Airport',fontSize:28),
                        //     //       TripLocationWidget(isFrom: false, title: offers?.tripDetails?.location
                        //     //           ?.toTitle ??
                        //     //           'Cairo International Airport',fontSize:28),
                        //     //       (offers?.tripDetails?.note==null||offers?.tripDetails?.note=='')?Label(
                        //     //         text:
                        //     //         '${LocaleKeys.passenger.localize} ${_formatNumber((offers?.tripDetails?.passengers ?? 0).toString(), context)}',
                        //     //         style: Styles.mediumText(),
                        //     //       ):Label(
                        //     //         text:
                        //     //         '${LocaleKeys.cargoDescription.localize}:\n ${offers?.tripDetails?.note}',
                        //     //         style: Styles.mediumText(),
                        //     //         maxLines: 2,
                        //     //       ),
                        //     //     ],
                        //     //   ),
                        //     // ),
                        //     Expanded(
                        //         flex: 3,
                        //         child: Column(
                        //           children: [
                        //             // offers?.category?.picture != null
                        //             //     ? Image.asset(Assets.rideIcon,
                        //             //     width: 40, height: 40, fit: BoxFit.cover)
                        //             //     :
                        //             ImageFromInternet(
                        //                 image:
                        //                 offers?.subCategory?.pictureUrl ?? '',
                        //                 width: 40,
                        //                 height: 40,
                        //                 fit: BoxFit.contain),
                        //             Label(
                        //                 text: context.isArabic
                        //                     ? (offers?.subCategory?.nameAr ?? '')
                        //                     : (offers?.subCategory?.nameEn ?? ''),
                        //                 style: Styles.mediumText(fontSize: 25))
                        //           ],
                        //         )),
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Label(
                              text: formatPrice(
                                  (offers?.tripDetails?.price ?? 0) > 0
                                      ? (offers?.tripDetails?.price ?? 0)
                                      : (offers?.tripDetails?.price ?? 0),
                                  context),
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.w700),
                            ),
                            const Sizer(width: 4),
                            Label(
                              text: LocaleKeys.egp.tr(),
                              style: Styles.mediumText(
                                color: AppColors.SECONDARY_COLOR,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            // offers?.category?.picture != null
                            //     ? Image.asset(Assets.rideIcon,
                            //     width: 40, height: 40, fit: BoxFit.cover)
                            //     :
                            ImageFromInternet(
                                image: offers?.tripDetails?.category?.picture ??
                                    '',
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain),
                            Label(
                                text: context.isArabic
                                    ? (offers?.tripDetails?.category?.nameAr ??
                                        '')
                                    : (offers?.tripDetails?.category?.nameEn ??
                                        ''),
                                style: Styles.mediumText(fontSize: 25))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Sizer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Label(
                      text: formatTimeOnly(offers?.tripDetails?.date, context),
                      style: Styles.mediumText(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Label(
                      text:
                          formatPickupDate(offers?.tripDetails?.date, context),
                      style: Styles.mediumText(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
