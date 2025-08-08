import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../common/widgets/stateless/verified_widget.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../data/models/loading/get_loading_accepted_model.dart';
import '../../controllers/dashboards_cubit/dashboards_cubit.dart';
import 'loading_dashboard_details_screen.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

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
        decoration: BoxDecoration(
            color: context.isDarkMode
                ? AppColors.PRIMARY_COLOR
                : AppColors.cF5F5F5,
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
                            child: offers?.client?.profilePictureKey == null ||
                                    offers!.client!.profilePictureKey!.isEmpty
                                ? Image.asset(
                                    Assets.maleImagePlaceholder,
                                    fit: BoxFit.cover,
                                  )
                                : ImageFromInternet(
                                    image: offers!.client!.profilePictureKey!,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Row(children: [
                                    SvgPicture.asset(Assets.star2,
                                        width: 8, height: 8),
                                    const Sizer(width: 4),
                                    Label(
                                        text: formatPrice(offers?.client?.rating?.count ?? 0,context),
                                        style: Styles.smallText(
                                            color: AppColors.PRIMARY_COLOR))
                                  ])))),
                      const VerifiedWidget(),
                    ],
                  ),
                  Label(
                      text: offers?.client?.firstName ?? '',
                      style: Styles.mediumText()),
                  // Label(
                  //     text:
                  //     '(${offers?.clientDetails?.rating?.average ?? 0})',
                  //     style: Styles.smallText())
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
                                          text: offers?.tripDetails?.location
                                                  ?.toTitle ??
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
                                          text: offers?.tripDetails?.location
                                                  ?.fromTitle ??
                                              'Cairo International Airport',
                                          style: Styles.mediumText(
                                              fontWeight: FontWeight.w300)))
                                ],
                              ),
                              Label(
                                  text:
                                      offers?.tripDetails?.cargoDescription ?? "",
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
                                    image: offers!
                                            .tripDetails!.category?.picture ??
                                        "",
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain),
                                Label(
                                    text: context.isArabic
                                        ? (offers?.tripDetails!.category
                                                ?.nameAr ??
                                            '')
                                        : (offers?.tripDetails!.category
                                                ?.nameEn ??
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
                            text: formatPrice(offers?.tripDetails?.price ?? 100, context),
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
                          text:  formatTimeOnly(offers?.tripDetails?.date,context) ,
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w700
                          ),
                        ),
                        Label(
                          text: formatPickupDate( offers?.tripDetails?.date,context) ,
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
      ),
    );
  }
}