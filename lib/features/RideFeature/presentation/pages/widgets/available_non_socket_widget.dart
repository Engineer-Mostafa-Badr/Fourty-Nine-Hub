
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../common/widgets/stateless/verified_widget.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../domain/entities/dashboards/get_available_ride_non_socket_trip_entity.dart';
import '../../../domain/usecases/dashboards/create_non_track_offer_use_case.dart';
import '../../controllers/dashboards_cubit/dashboards_cubit.dart';

class AvailableNonSocketWidget extends StatelessWidget {
  final String modeType;
  final AvailableRideNonSocketTripEntity? offers;
  const AvailableNonSocketWidget(
      {super.key, this.modeType = 'truk', this.offers});

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
            color:
            context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.cF5F5F5,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClickableWidget(
              onTap: () {
                context.push(
                  Routes.allClientRatingScreen,
                extra:offers?.clientDetails?.id,
                );
              },
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
                          child: offers?.clientDetails?.profilePictureUrl ==
                              null ||
                              offers!
                                  .clientDetails!.profilePictureUrl!.isEmpty
                              ? Image.asset(
                            Assets.maleImagePlaceholder,
                            fit: BoxFit.cover,
                          )
                              : ImageFromInternet(
                            image:  offers!
                                .clientDetails!.profilePictureUrl!,
                          )
                      ),
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
                                      text: offers
                                          ?.clientDetails?.rating?.count
                                          .toString() ??
                                          '0',
                                      style: Styles.smallText(
                                        color: AppColors.PRIMARY_COLOR
                                      ))
                                ])))),
                    const VerifiedWidget(),
                  ],
                ),
                Label(
                    text: offers?.clientDetails?.firstName ?? '',
                    style: Styles.mediumText()),
                // Label(
                //     text:
                //     '(${offers?.clientDetails?.rating?.average ?? 0})',
                //     style: Styles.smallText())
              ]),
            ),
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
                                          text: offers?.tripDetails?.startLocation?.title ??
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
                                          text: offers?.tripDetails?.targetLocation?.title ??
                                              'Cairo International Airport',
                                          style: Styles.mediumText(
                                              fontWeight: FontWeight.w300)))
                                ],
                              ),
                              Label(
                                  text: '${LocaleKeys.passenger.localize}  ${offers?.tripDetails?.passengers ?? 0}',
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
                                    image: offers!.subCategory?.pictureUrl?? "",
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain),
                                Label(
                                    text: context.isArabic
                                        ? (offers?.subCategory?.nameAr ?? '')
                                        : (offers?.subCategory?.nameEn ?? ''),
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
                            text: "${offers?.tripDetails?.price ?? 300}",
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
                          text: formattedTime, //'10 AM',
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Label(
                          text: formattedDate, //'20/2/2025',
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AppButton(
                            // label: "",
                            height: 30,
                            radius: 15,
                            widget:   Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Label(
                                      text: "${LocaleKeys.Accept.tr()} ${offers?.tripDetails?.price ?? 0}",
                                      style:
                                          Styles.mediumText(
                                            color:  Colors.white,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              final price = offers?.tripDetails?.price ?? 0;
                              final tripId = offers?.tripDetails?.id  ?? '';
                              print("XXQ ${tripId}");
                              print("XXQ ${offers?.tripDetails?.id }");
                              context.read<DashboardsCubit>().createNonTrackOffer(
                                CreateNonTrackOfferParams(
                                  tripId: tripId,
                                  priceOffer: price,
                                ),
                                  context,
                                  offers?.subCategory?.id ?? ""
                              );
                            },
                            backColor: context.isDarkMode
                                ? AppColors.ACCENT_COLOR
                                : AppColors.PRIMARY_COLOR,
                          ),
                        ),
                        const Sizer(),
                        Expanded(
                          child: AppButton(
                            radius: 15,
                            height: 30,
                            label: LocaleKeys.acceptAnothePrice.tr(),
                            style: Styles.mediumText(
                              color: Colors.white,
                              fontSize: 23,
                            ),
                            onPressed: () {
                              _showOfferFareBottomSheet(context, offers?.tripDetails?.id ?? '');
                            },
                            backColor: AppColors.SECONDARY_COLOR_DARK2,
                          ),
                        ),
                      ],
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Expanded(
                    //       child: AppButton(
                    //           height: 30,
                    //           radius: 15,
                    //           label: LocaleKeys.Accept.tr(),
                    //           onPressed: () {},
                    //           backColor:context.isDarkMode ? AppColors.ACCENT_COLOR : AppColors.PRIMARY_COLOR
                    //       ),
                    //     ),
                    //     const Sizer(),
                    //     Expanded(
                    //       child: AppButton(
                    //           radius: 15,
                    //           height: 30,
                    //           label: LocaleKeys.acceptAnothePrice.tr(),
                    //           style: Styles.mediumText(
                    //               color: Colors.white, fontSize: 23),
                    //           onPressed: () {},
                    //           backColor: AppColors.SECONDARY_COLOR_DARK2
                    //
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
);
  }
  void _showOfferFareBottomSheet(
      BuildContext context,
      String tripId,
      ) {
    final TextEditingController offerPriceController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.whiteColor,
      builder: (context) {
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: 0.75,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Label(
                        text: LocaleKeys.offerYourFare.localize,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.PRIMARY_COLOR),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppColors.cEEEEEEE,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              color: AppColors.PRIMARY_COLOR),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: offerPriceController,
                  keyboardType: TextInputType.number,
                  decoration:  InputDecoration(
                    hintText: LocaleKeys.egp.tr(),
                    hintStyle: TextStyle(fontSize: 40, color: AppColors.c96979B),
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.PRIMARY_COLOR),
                ),
                const SizedBox(height: 50),
                AppButton(
                  radius: 15,
                  backColor: AppColors.PRIMARY_COLOR,
                  onPressed: () {
                    final enteredPrice =
                        num.tryParse(offerPriceController.text) ?? 0;
                    Navigator.pop(context);

                    context.read<DashboardsCubit>().createNonTrackOffer(
                      CreateNonTrackOfferParams(
                        tripId: tripId,
                        priceOffer: enteredPrice,
                      ),
                        context,
                        offers?.subCategory?.id ?? ""
                    );
                  },
                  label: LocaleKeys.done.localize,
                  style: const TextStyle(
                    color: AppColors.LIGHT_COLOR,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
