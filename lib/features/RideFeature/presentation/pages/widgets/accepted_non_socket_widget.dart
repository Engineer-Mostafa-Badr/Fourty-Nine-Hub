import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/loading_dashboard/loading_dashboard_details_screen.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../common/widgets/stateless/verified_widget.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../domain/entities/dashboards/get_accepted_ride_non_socket_trip_entity.dart';

class AcceptedNonSocketWidget extends StatelessWidget {
  final AcceptedRideNonSocketTripEntity? offers;

  const AcceptedNonSocketWidget({super.key, this.offers});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(
        offers?.tripDate?.createdAt ?? '2025-03-11T21:50:21.998Z');
    String formattedDate =
        "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
    String formattedTime =
        "${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12} ${dateTime.hour < 12 ? 'AM' : 'PM'}";
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color:
              context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.cF5F5F5,
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 2,
              child: Column(children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Container(
                          width: 50,
                          height: 50,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: offers?.clientDetails?.profilePictureKey ==
                                      null ||
                                  offers!
                                      .clientDetails!.profilePictureKey!.isEmpty
                              ? Image.asset(
                                  Assets.maleImagePlaceholder,
                                  fit: BoxFit.cover,
                                )
                              : ImageFromInternet(
                                  image:
                                      offers!.clientDetails!.profilePictureKey!,
                                )),
                    ),
                    Positioned(
                        top: 0,
                        right: -5,
                        child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.cF5F5F5,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Row(children: [
                                  SvgPicture.asset(Assets.star2,
                                      width: 8, height: 8),
                                  const Sizer(width: 4),
                                  Label(
                                      text: formatPrice(
                                          offers?.clientDetails?.rating?.count
                                                  ?.toDouble() ??
                                              0,
                                          context),
                                      style: Styles.smallText(
                                          color: AppColors.PRIMARY_COLOR))
                                ])))),
                    const VerifiedWidget(),
                  ],
                ),
                Label(
                    text: offers?.clientDetails?.firstName ?? '',
                    style: Styles.mediumText()),
                Label(
                    text:
                        '(${formatPrice(offers?.clientDetails?.rating?.average ?? 0, context)})',
                    style: Styles.smallText())
              ])),
          const Sizer(width: 32),
          Expanded(
            flex: 8,
            child: IntrinsicWidth(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Image.asset(Assets.rideFrom,
                                      width: 24, height: 24),
                                ),
                                Expanded(
                                    flex: 8,
                                    child: Label(
                                        text: offers?.tripDate?.location
                                                ?.fromTitle ??
                                            'Cairo International Airport',
                                        style: Styles.headerText()))
                              ],
                            ),
                            Row(
                              spacing: 5,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Image.asset(Assets.rideTo,
                                        width: 24, height: 24)),
                                Expanded(
                                    flex: 8,
                                    child: Label(
                                        text: offers?.tripDate?.location
                                                ?.fromTitle ??
                                            'Cairo International Airport',
                                        style: Styles.mediumText(
                                            fontWeight: FontWeight.w300)))
                              ],
                            ),
                            Label(
                                text:
                                    '${LocaleKeys.passenger.localize}  ${formatPrice(offers?.tripDate?.passengers ?? 1, context)}',
                                style: Styles.mediumText())
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              // offers?.category?.picture != null
                              //     ? Image.asset(Assets.rideIcon,
                              //     width: 40, height: 40, fit: BoxFit.cover)
                              //     :
                              ImageFromInternet(
                                  image: offers!.tripDate!.category!.picture!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain),
                              Label(
                                  text: context.isArabic
                                      ? (offers?.tripDate?.category?.nameAr ??
                                          '')
                                      : (offers?.tripDate?.category?.nameEn ??
                                          ''),
                                  style: Styles.mediumText(fontSize: 25))
                            ],
                          )),
                    ],
                  ),
                  // Label(
                  //   text: modeType == 'truk'
                  //       ? "${LocaleKeys.cargoDescription.tr()} : Car"
                  //       : '${LocaleKeys.passenger.tr()} : ${offers?.tripDetails?.passengers ?? 0}',
                  //   style: Styles.mediumText(fontSize: 32),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Label(
                          text: formatPrice(
                              offers?.tripDate?.price ?? 300, context),
                          style:
                              Styles.mediumText(fontWeight: FontWeight.w700)),
                      const Sizer(width: 4),
                      Label(
                          text: LocaleKeys.egp.tr(),
                          style: Styles.mediumText(
                              color: AppColors.SECONDARY_COLOR,
                              fontWeight: FontWeight.w700))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Label(
                        text: formatTimeOnly(offers?.tripDate?.date, context),
                        style: Styles.mediumText(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Label(
                        text: formatPickupDate(offers?.tripDate?.date, context),
                        style: Styles.mediumText(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: SvgPicture.asset(
                            Assets.phoneIconRed,
                            width: 30.w,
                            height: 30.h,
                            color: context.isDarkMode
                                ? AppColors.PRIMARY_COLOR_DARK
                                : AppColors.PRIMARY_COLOR,
                          ),
                          onPressed: () {
                            ManageVibration.vibrate();
                          },
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                            icon: SvgPicture.asset(
                              Assets.mailIconRed,
                              width: 25.w,
                              height: 25.h,
                              color: context.isDarkMode
                                  ? AppColors.PRIMARY_COLOR_DARK
                                  : AppColors.PRIMARY_COLOR,
                            ),
                            onPressed: () {
                              ManageVibration.vibrate();
                            }),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: SvgPicture.asset(
                            Assets.reportRed,
                            width: 25.w,
                            height: 25.h,
                            color: AppColors.PRIMARY_COLOR_DARK,
                          ),
                          onPressed: () {
                            ManageVibration.vibrate();
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
