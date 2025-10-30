import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/core/widget/common/profile_picture_widget.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/dashboards_cubit/dashboards_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/ride_mode_screen.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import 'package:toastification/toastification.dart';

class AvailableTripCard extends StatefulWidget {
  const AvailableTripCard(
      {super.key, required this.trip, required this.params, this.onCancel});
  final AvailableTripEntity trip;
  final RideModeParams params;
  final Function(AvailableTripEntity trip)? onCancel;
  @override
  State<AvailableTripCard> createState() => _AvailableTripCardState();
}

class _AvailableTripCardState extends State<AvailableTripCard> {
  Timer? _timer;
  Duration? _remainingTime;
  bool _isButtonDisabled = false;

  Future<void> _checkTimerStatus() async {
    // Clean up expired timers first
    await CacheManager.cleanupExpiredTimers();

    // Check if this trip has an active timer
    final tripId = widget.trip.id;
    final remaining =
        await CacheManager.getTripOfferRemainingTime(tripId ?? '');

    if (remaining != null && remaining.inSeconds > 0) {
      setState(() {
        _remainingTime = remaining;
        _isButtonDisabled = true;
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    final tripId = widget.trip.id;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final remaining =
          await CacheManager.getTripOfferRemainingTime(tripId ?? '');

      if (remaining != null && remaining.inSeconds > 0) {
        setState(() {
          _remainingTime = remaining;
        });
      } else {
        setState(() {
          _remainingTime = null;
          _isButtonDisabled = false;
        });
        _timer?.cancel();
      }
    });
  }

  Future<void> _saveOfferTimer() async {
    final expireTime = DateTime.now().add(const Duration(seconds: 10));
    final tripId = widget.trip.id;
    await CacheManager.saveTripOfferTimer(tripId ?? '', expireTime);
    setState(() {
      _remainingTime = const Duration(seconds: 10);
      _isButtonDisabled = true;
    });
    _startTimer();
  }

  @override
  void initState() {
    super.initState();
    _checkTimerStatus();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardsCubit, DashboardsState>(
        builder: (context, state) {
      var cubit = context.read<DashboardsCubit>();
      num offer = (widget.trip.offerPriceRange?.lastOffer ?? 0) + 3 >
              (widget.trip.offerPriceRange?.highestFare ?? 0)
          ? (widget.trip.offerPriceRange?.highestFare ?? 0)
          : (widget.trip.offerPriceRange?.lastOffer ?? 0);
      print("offer $offer");
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with X button and badge
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     // IconButton(
              //     //   icon: const Icon(Icons.close, color: Colors.black),
              //     //   onPressed: () => _removeCurrentCard(person),
              //     //   padding: EdgeInsets.zero,
              //     //   constraints: const BoxConstraints(),
              //     // ),
              //     Expanded(child: Row(
              //       children: [
              //         Image.asset(Assets.car2Image,width: 80,height: 30,),
              //         Text(context.isArabic?'كابتن':'Captain',style: TextStyle(
              //           fontSize: FontSize.s14,
              //           color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR
              //         ),)
              //       ],
              //     )),
              //     Image.asset(Assets.logoHub,width: 80,height: 30,),
              //   ],
              // ),
              // const SizedBox(height: 4),

              // Price section

              // Service fee
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              FormatNumbers().convertNumberToLocalizedString(
                                  (widget.trip.price ?? 0).ceil().toString(),
                                  isArabic: context.isArabic),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Baseline(
                              baselineType: TextBaseline.alphabetic,
                              baseline: context.isArabic ? 20 : 30,
                              child: Text(
                                ' ${context.isArabic ? 'ج.م' : 'EGP'}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            if ((widget.trip.platformFee ?? 0) > 0) ...[
                              Sizer(
                                width: 10,
                              ),
                              Baseline(
                                baselineType: TextBaseline.alphabetic,
                                baseline: 20,
                                child: Text(
                                  '${FormatNumbers().convertNumberToLocalizedString(FormatNumbers().convertNumberToLocalizedString((widget.trip.platformFee ?? 0).ceil().toString(), isArabic: context.isArabic), isArabic: context.isArabic)} ${context.isArabic ? 'رسوم' : 'service'}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              )
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        // Row(
                        //   children: [
                        //     Icon(Icons.star, size: 14, color: Colors.grey[600]),
                        //     const SizedBox(width: 4),
                        //     Text(
                        //       '${person.serviceFee} ${context.isArabic?'صافي رسوم الخدمة':'Net service fees'}',
                        //       style: TextStyle(
                        //         fontSize: 12,
                        //         color: Colors.grey[600],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 4),

                        // Driver info
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                context.isArabic
                                    ? 'على بعد ${FormatNumbers().convertNumberToLocalizedString((widget.trip.route?.driverPosition?.durationToPickup ?? 0).ceil().toString(), isArabic: context.isArabic)} د - (${FormatNumbers().convertNumberToLocalizedString((widget.trip.route?.driverPosition?.distanceToPickup ?? 0).ceil().toString(), isArabic: context.isArabic)}) كيلومتر'
                                    : '${FormatNumbers().convertNumberToLocalizedString((widget.trip.route?.driverPosition?.durationToPickup ?? 0).ceil().toString(), isArabic: context.isArabic)} min - (${FormatNumbers().convertNumberToLocalizedString((widget.trip.route?.driverPosition?.distanceToPickup ?? 0).ceil().toString(), isArabic: context.isArabic)}) km away',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Sizer(
                              width: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  widget.trip.isComfort == true
                                      ? Assets.airConditioner
                                      : Assets.noAirConditioner,
                                  width: 18,
                                  height: 18,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  widget.trip.isNonSmoking == true
                                      ? Assets.noSmokingIcon
                                      : Assets.smokingIcon,
                                  width: 18,
                                  height: 18,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: AppColors.ACCENT_COLOR,
                                size: 12,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                '(${FormatNumbers().convertNumberToLocalizedString('2', isArabic: context.isArabic)})',
                                style: Styles.mediumText(
                                    color: context.isDarkMode
                                        ? Colors.white
                                        : AppColors.PRIMARY_COLOR,
                                    fontSize: 20),
                              )
                            ],
                          ),
                          Sizer(
                            width: 10,
                          ),
                          ProfilePictureWidget(
                            image: '',
                            segments: 0,
                            hasStories: false,
                            isMale: widget.trip.clientDetails?.gender == 'male',
                            firstChar:
                                (widget.trip.clientDetails?.firstName ?? ' ')[0]
                                    .toUpperCase(),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (widget.trip.clientDetails?.isAccountVerified ==
                                true) ...[
                              Icon(
                                Icons.verified,
                                color: Colors.blueAccent,
                                size: 14,
                              ),
                              Sizer(
                                width: 10,
                              )
                            ],
                            Text(
                              widget.trip.clientDetails?.firstName ?? '',
                              style: Styles.mediumText(
                                  color: context.isDarkMode
                                      ? AppColors.whiteColor
                                      : AppColors.PRIMARY_COLOR),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Route section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vertical line with markers
                  // Column(
                  //   children: [
                  //     // Top marker
                  //     Container(
                  //       width: 12,
                  //       height: 12,
                  //       decoration: BoxDecoration(
                  //         color: const Color(0xFF2C2C2C),
                  //         borderRadius: BorderRadius.circular(2),
                  //       ),
                  //     ),
                  //     const SizedBox(height: 4),
                  //     // Vertical line
                  //     Container(
                  //       width: 2,
                  //       height: 40,
                  //       color: Colors.grey[300],
                  //     ),
                  //     const SizedBox(height: 4),
                  //     // Bottom marker
                  //     Container(
                  //       width: 12,
                  //       height: 12,
                  //       decoration: BoxDecoration(
                  //         color: const Color(0xFF2C2C2C),
                  //         borderRadius: BorderRadius.circular(2),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  _buildStepperLine(context),
                  const SizedBox(width: 12),

                  // Locations
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pickup location
                        Text(
                          widget.trip.route?.pickupPoint?.address ?? '',
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Trip details
                        Text(
                          context.isArabic
                              ? 'مشوار لمدة ${FormatNumbers().convertNumberToLocalizedString((widget.trip.route?.dropPoint?.durationFromPickup ?? 0).ceil().toString(), isArabic: context.isArabic)} د - المسافة ${"( ${FormatNumbers().convertNumberToLocalizedString((widget.trip.route?.dropPoint?.distanceFromPickup ?? 0).ceil().toString(), isArabic: context.isArabic)}"} كيلومتر)'
                              : '${FormatNumbers().convertNumberToLocalizedString((widget.trip.route?.dropPoint?.durationFromPickup ?? 0).ceil().toString(), isArabic: context.isArabic)} minute walk - distance (${FormatNumbers().convertNumberToLocalizedString((widget.trip.route?.dropPoint?.distanceFromPickup ?? 0).ceil().toString(), isArabic: context.isArabic)} km)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Drop-off location
                        Text(
                          widget.trip.route?.dropPoint?.address ?? '',
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ReadMoreText(
                widget.trip.description ?? '',
                trimMode: TrimMode.Line,
                trimLines: 2,
                colorClickableText: AppColors.SECONDARY_COLOR,
                trimCollapsedText: context.isArabic ? ' المزيد ' : ' More ',
                trimExpandedText: context.isArabic ? ' أقل ' : ' Less ',
                style: Styles.mediumText(
                    color: context.isDarkMode
                        ? AppColors.whiteColor
                        : AppColors.PRIMARY_COLOR),
              ),
              const SizedBox(height: 4),
              // Confirm button
              Row(
                children: [
                  ClickableWidget(
                    onTap: () {
                      if (_isButtonDisabled ||
                          ((widget.trip.offerPriceRange?.lastOffer ?? 0) + 3 >
                              (widget.trip.offerPriceRange?.highestFare ?? 0)))
                        return;
                      ManageVibration.vibrate();
                      if (widget.trip.isPremium == true ||
                          widget.trip.state?.isButtonEnabled == true) {
                        if (widget.trip.isAutoAccept == false) {
                          cubit.createOffer(
                              tripId: widget.trip.id ?? '',
                              price:
                                  ((widget.trip.offerPriceRange?.lastOffer ?? 0)
                                          .ceil() +
                                      3),
                              context: context,
                              subCategoryId: widget.trip.subcategory?.id ?? '',
                              onSuccess: () {
                                widget.trip.offerPriceRange?.lastOffer =
                                    ((widget.trip.offerPriceRange?.lastOffer ??
                                                0)
                                            .ceil() +
                                        3);
                                // Save timer when offer is sent
                                _saveOfferTimer();
                                final currentContext = AppPages.router
                                    .configuration.navigatorKey.currentContext!;
                                currentContext.pop();
                                toastification.show(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentContext.isArabic
                                            ? "تم ارسال العرض بنجاح"
                                            : "Offer sent successfully",
                                        style: TextStyle(
                                          color: currentContext.isDarkMode
                                              ? AppColors.whiteColor
                                              : AppColors.PRIMARY_COLOR,
                                          fontSize: 32.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  autoCloseDuration: const Duration(seconds: 5),
                                  progressBarTheme: ProgressIndicatorThemeData(
                                      color: AppColors.SECONDARY_COLOR),
                                  primaryColor: AppColors.SECONDARY_COLOR,
                                  backgroundColor: Theme.of(currentContext)
                                      .dialogBackgroundColor,
                                  showProgressBar: true,
                                );
                              });
                        } else {
                          cubit.autoAcceptTrip(
                              context, widget.trip.id ?? '', widget.params);
                        }
                      } else {
                        SubscriptionMethod().subscribe(
                            subscribeId: widget.trip.subcategory?.id ?? '',
                            showRegular: true,
                            title: LocaleKeys.premiumRequest.localize);
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: (_isButtonDisabled && _remainingTime != null ||
                                (((widget.trip.offerPriceRange?.lastOffer ??
                                            0) +
                                        3 >
                                    (widget.trip.offerPriceRange?.highestFare ??
                                        0))))
                            ? AppColors.GREY_DARK_COLOR
                            : AppColors.PRIMARY_COLOR,
                      ),
                      child: Text(
                        '+${FormatNumbers().convertNumberToLocalizedString('3', isArabic: context.isArabic)}',
                        style: Styles.mediumText(
                            color: AppColors.whiteColor, fontSize: 30),
                      ),
                    ),
                  ),
                  Sizer(width: 8),
                  Expanded(
                      child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle confirm action
                        if (_isButtonDisabled) return;
                        ManageVibration.vibrate();
                        if (widget.trip.isPremium == true ||
                            widget.trip.state?.isButtonEnabled == true) {
                          if (widget.trip.isAutoAccept == false) {
                            cubit.createOffer(
                                tripId: widget.trip.id ?? '',
                                price: offer,
                                context: context,
                                subCategoryId:
                                    widget.trip.subcategory?.id ?? '',
                                onSuccess: () {
                                  // Save timer when offer is sent
                                  _saveOfferTimer();
                                  final currentContext = AppPages
                                      .router
                                      .configuration
                                      .navigatorKey
                                      .currentContext!;
                                  currentContext.pop();
                                  toastification.show(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentContext.isArabic
                                              ? "تم ارسال العرض بنجاح"
                                              : "Offer sent successfully",
                                          style: TextStyle(
                                            color: currentContext.isDarkMode
                                                ? AppColors.whiteColor
                                                : AppColors.PRIMARY_COLOR,
                                            fontSize: 32.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    autoCloseDuration:
                                        const Duration(seconds: 5),
                                    progressBarTheme:
                                        ProgressIndicatorThemeData(
                                            color: AppColors.SECONDARY_COLOR),
                                    primaryColor: AppColors.SECONDARY_COLOR,
                                    backgroundColor: Theme.of(currentContext)
                                        .dialogBackgroundColor,
                                    showProgressBar: true,
                                  );
                                });
                          } else {
                            cubit.autoAcceptTrip(
                                context, widget.trip.id ?? '', widget.params);
                          }
                        } else {
                          SubscriptionMethod().subscribe(
                              subscribeId: widget.trip.subcategory?.id ?? '',
                              showRegular: true,
                              title: LocaleKeys.premiumRequest.localize);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            (_isButtonDisabled && _remainingTime != null)
                                ? AppColors.GREY_DARK_COLOR
                                : AppColors.PRIMARY_COLOR,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _isButtonDisabled && _remainingTime != null
                            ? '${_remainingTime!.inSeconds} ${context.isArabic ? 'ث' : 's'}'
                            : context.isArabic
                                ? 'القبول مقابل ${FormatNumbers().convertNumberToLocalizedString(offer.floor().toString(), isArabic: context.isArabic)} ج.م'
                                : 'Accept for ${FormatNumbers().convertNumberToLocalizedString(offer.floor().toString(), isArabic: context.isArabic)} EGP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )),
                  Sizer(width: 8),
                  ClickableWidget(
                    onTap: () {
                      if (_isButtonDisabled ||
                          (((widget.trip.offerPriceRange?.lastOffer ?? 0) - 3) <
                              (widget.trip.offerPriceRange?.lowestFare ?? 0)))
                        return;
                      ManageVibration.vibrate();
                      if (widget.trip.isPremium == true ||
                          widget.trip.state?.isButtonEnabled == true) {
                        if (widget.trip.isAutoAccept == false) {
                          cubit.createOffer(
                              tripId: widget.trip.id ?? '',
                              price:
                                  ((widget.trip.offerPriceRange?.lastOffer ?? 0)
                                          .ceil() -
                                      3),
                              context: context,
                              subCategoryId: widget.trip.subcategory?.id ?? '',
                              onSuccess: () {
                                widget.trip.offerPriceRange?.lastOffer =
                                    ((widget.trip.offerPriceRange?.lastOffer ??
                                                0)
                                            .ceil() -
                                        3);
                                // Save timer when offer is sent
                                _saveOfferTimer();
                                final currentContext = AppPages.router
                                    .configuration.navigatorKey.currentContext!;
                                currentContext.pop();
                                toastification.show(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentContext.isArabic
                                            ? "تم ارسال العرض بنجاح"
                                            : "Offer sent successfully",
                                        style: TextStyle(
                                          color: currentContext.isDarkMode
                                              ? AppColors.whiteColor
                                              : AppColors.PRIMARY_COLOR,
                                          fontSize: 32.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  autoCloseDuration: const Duration(seconds: 5),
                                  progressBarTheme: ProgressIndicatorThemeData(
                                      color: AppColors.SECONDARY_COLOR),
                                  primaryColor: AppColors.SECONDARY_COLOR,
                                  backgroundColor: Theme.of(currentContext)
                                      .dialogBackgroundColor,
                                  showProgressBar: true,
                                );
                              });
                        } else {
                          cubit.autoAcceptTrip(
                              context, widget.trip.id ?? '', widget.params);
                        }
                      } else {
                        SubscriptionMethod().subscribe(
                            subscribeId: widget.trip.subcategory?.id ?? '',
                            showRegular: true,
                            title: LocaleKeys.premiumRequest.localize);
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: (_isButtonDisabled && _remainingTime != null ||
                                (((widget.trip.offerPriceRange?.lastOffer ?? 0)
                                            .ceil() -
                                        3) <
                                    (widget.trip.offerPriceRange?.lowestFare ??
                                            0)
                                        .floor()))
                            ? AppColors.GREY_DARK_COLOR
                            : AppColors.PRIMARY_COLOR,
                      ),
                      child: Text(
                        '-${FormatNumbers().convertNumberToLocalizedString('3', isArabic: context.isArabic)}',
                        style: Styles.mediumText(
                            color: AppColors.whiteColor, fontSize: 30),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ClickableWidget(
                      onTap: () {
                        if (_isButtonDisabled) return;
                        ManageVibration.vibrate();
                        if (widget.trip.isPremium == true ||
                            widget.trip.state?.isButtonEnabled == true) {
                          if (widget.trip.isAutoAccept == false) {
                            cubit.createOffer(
                                tripId: widget.trip.id ?? '',
                                price:
                                    ((widget.trip.offerPriceRange?.lowestFare ??
                                                    0)
                                                .ceil() +
                                            (((widget.trip.offerPriceRange
                                                            ?.highestFare ??
                                                        0) -
                                                    (widget.trip.offerPriceRange
                                                            ?.lowestFare ??
                                                        0)) *
                                                0.2))
                                        .ceil(),
                                context: context,
                                subCategoryId:
                                    widget.trip.subcategory?.id ?? '',
                                onSuccess: () {
                                  // Save timer when offer is sent
                                  widget.trip.offerPriceRange
                                      ?.lastOffer = ((widget
                                                  .trip
                                                  .offerPriceRange
                                                  ?.lowestFare ??
                                              0) +
                                          (((widget.trip.offerPriceRange
                                                              ?.highestFare ??
                                                          0)
                                                      .ceil() -
                                                  (widget.trip.offerPriceRange
                                                          ?.lowestFare ??
                                                      0)) *
                                              0.2))
                                      .ceil();
                                  _saveOfferTimer();
                                  final currentContext = AppPages
                                      .router
                                      .configuration
                                      .navigatorKey
                                      .currentContext!;
                                  currentContext.pop();
                                  toastification.show(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentContext.isArabic
                                              ? "تم ارسال العرض بنجاح"
                                              : "Offer sent successfully",
                                          style: TextStyle(
                                            color: currentContext.isDarkMode
                                                ? AppColors.whiteColor
                                                : AppColors.PRIMARY_COLOR,
                                            fontSize: 32.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    autoCloseDuration:
                                        const Duration(seconds: 5),
                                    progressBarTheme:
                                        ProgressIndicatorThemeData(
                                            color: AppColors.SECONDARY_COLOR),
                                    primaryColor: AppColors.SECONDARY_COLOR,
                                    backgroundColor: Theme.of(currentContext)
                                        .dialogBackgroundColor,
                                    showProgressBar: true,
                                  );
                                });
                          } else {
                            cubit.autoAcceptTrip(
                                context, widget.trip.id ?? '', widget.params);
                          }
                        } else {
                          SubscriptionMethod().subscribe(
                              subscribeId: widget.trip.subcategory?.id ?? '',
                              showRegular: true,
                              title: LocaleKeys.premiumRequest.localize);
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: _isButtonDisabled && _remainingTime != null
                              ? AppColors.GREY_DARK_COLOR
                              : AppColors.PRIMARY_COLOR,
                        ),
                        child: Center(
                            child: Text(
                          '${FormatNumbers().convertNumberToLocalizedString(((widget.trip.offerPriceRange?.lowestFare ?? 0).ceil() + (((widget.trip.offerPriceRange?.highestFare ?? 0) - (widget.trip.offerPriceRange?.lowestFare ?? 0)) * 0.2)).ceil().toString(), isArabic: context.isArabic)} ${context.isArabic ? 'ج.م' : 'EGP'}',
                          textAlign: TextAlign.center,
                          style: Styles.mediumText(color: AppColors.whiteColor),
                        )),
                      ),
                    ),
                  ),
                  Sizer(width: 4),
                  Expanded(
                    flex: 1,
                    child: ClickableWidget(
                      onTap: () {
                        if (_isButtonDisabled) return;
                        ManageVibration.vibrate();
                        print("tripEntity.isPremium ${widget.trip.isPremium}");
                        print(
                            "tripEntity.isButtonEnabled ${widget.trip.state?.isButtonEnabled}");
                        if (widget.trip.isPremium == true ||
                            widget.trip.state?.isButtonEnabled == true) {
                          if (widget.trip.isAutoAccept == false) {
                            cubit.createOffer(
                                tripId: widget.trip.id ?? '',
                                price:
                                    ((widget.trip.offerPriceRange?.lowestFare ??
                                                    0)
                                                .ceil() +
                                            (((widget.trip.offerPriceRange
                                                            ?.highestFare ??
                                                        0) -
                                                    (widget.trip.offerPriceRange
                                                            ?.lowestFare ??
                                                        0)) *
                                                0.5))
                                        .ceil(),
                                context: context,
                                subCategoryId:
                                    widget.trip.subcategory?.id ?? '',
                                onSuccess: () {
                                  widget.trip.offerPriceRange
                                      ?.lastOffer = ((widget
                                                  .trip
                                                  .offerPriceRange
                                                  ?.lowestFare ??
                                              0) +
                                          (((widget.trip.offerPriceRange
                                                              ?.highestFare ??
                                                          0)
                                                      .ceil() -
                                                  (widget.trip.offerPriceRange
                                                          ?.lowestFare ??
                                                      0)) *
                                              0.5))
                                      .ceil();
                                  // Save timer when offer is sent
                                  _saveOfferTimer();
                                  final currentContext = AppPages
                                      .router
                                      .configuration
                                      .navigatorKey
                                      .currentContext!;
                                  currentContext.pop();
                                  toastification.show(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentContext.isArabic
                                              ? "تم ارسال العرض بنجاح"
                                              : "Offer sent successfully",
                                          style: TextStyle(
                                            color: currentContext.isDarkMode
                                                ? AppColors.whiteColor
                                                : AppColors.PRIMARY_COLOR,
                                            fontSize: 32.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    autoCloseDuration:
                                        const Duration(seconds: 5),
                                    progressBarTheme:
                                        ProgressIndicatorThemeData(
                                            color: AppColors.SECONDARY_COLOR),
                                    primaryColor: AppColors.SECONDARY_COLOR,
                                    backgroundColor: Theme.of(currentContext)
                                        .dialogBackgroundColor,
                                    showProgressBar: true,
                                  );
                                });
                          } else {
                            cubit.autoAcceptTrip(
                                context, widget.trip.id ?? '', widget.params);
                          }
                        } else {
                          SubscriptionMethod().subscribe(
                              subscribeId: widget.trip.subcategory?.id ?? '',
                              showRegular: true,
                              title: LocaleKeys.premiumRequest.localize);
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: _isButtonDisabled && _remainingTime != null
                              ? AppColors.GREY_DARK_COLOR
                              : AppColors.PRIMARY_COLOR,
                        ),
                        child: Center(
                            child: Text(
                          '${FormatNumbers().convertNumberToLocalizedString(((widget.trip.offerPriceRange?.lowestFare ?? 0).ceil() + (((widget.trip.offerPriceRange?.highestFare ?? 0) - (widget.trip.offerPriceRange?.lowestFare ?? 0)) * 0.5)).ceil().toString(), isArabic: context.isArabic)} ${context.isArabic ? 'ج.م' : 'EGP'}',
                          textAlign: TextAlign.center,
                          style: Styles.mediumText(color: AppColors.whiteColor),
                        )),
                      ),
                    ),
                  ),
                  Sizer(width: 4),
                  Expanded(
                    flex: 1,
                    child: ClickableWidget(
                      onTap: () {
                        if (_isButtonDisabled) return;
                        ManageVibration.vibrate();
                        print("tripEntity.isPremium ${widget.trip.isPremium}");
                        print(
                            "tripEntity.isButtonEnabled ${widget.trip.state?.isButtonEnabled}");
                        if (widget.trip.isPremium == true ||
                            widget.trip.state?.isButtonEnabled == true) {
                          if (widget.trip.isAutoAccept == false) {
                            cubit.createOffer(
                                tripId: widget.trip.id ?? '',
                                price:
                                    ((widget.trip.offerPriceRange?.lowestFare ??
                                                0) +
                                            (((widget.trip.offerPriceRange
                                                            ?.highestFare ??
                                                        0) -
                                                    (widget.trip.offerPriceRange
                                                            ?.lowestFare ??
                                                        0)) *
                                                1))
                                        .floor(),
                                context: context,
                                subCategoryId:
                                    widget.trip.subcategory?.id ?? '',
                                onSuccess: () {
                                  widget.trip.offerPriceRange?.lastOffer =
                                      ((widget.trip.offerPriceRange
                                                      ?.lowestFare ??
                                                  0) +
                                              (((widget.trip.offerPriceRange
                                                              ?.highestFare ??
                                                          0) -
                                                      (widget
                                                              .trip
                                                              .offerPriceRange
                                                              ?.lowestFare ??
                                                          0)) *
                                                  1))
                                          .floor();
                                  // Save timer when offer is sent
                                  _saveOfferTimer();
                                  final currentContext = AppPages
                                      .router
                                      .configuration
                                      .navigatorKey
                                      .currentContext!;
                                  currentContext.pop();
                                  toastification.show(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentContext.isArabic
                                              ? "تم ارسال العرض بنجاح"
                                              : "Offer sent successfully",
                                          style: TextStyle(
                                            color: currentContext.isDarkMode
                                                ? AppColors.whiteColor
                                                : AppColors.PRIMARY_COLOR,
                                            fontSize: 32.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    autoCloseDuration:
                                        const Duration(seconds: 5),
                                    progressBarTheme:
                                        ProgressIndicatorThemeData(
                                            color: AppColors.SECONDARY_COLOR),
                                    primaryColor: AppColors.SECONDARY_COLOR,
                                    backgroundColor: Theme.of(currentContext)
                                        .dialogBackgroundColor,
                                    showProgressBar: true,
                                  );
                                });
                          } else {
                            cubit.autoAcceptTrip(
                                context, widget.trip.id ?? '', widget.params);
                          }
                        } else {
                          SubscriptionMethod().subscribe(
                              subscribeId: widget.trip.subcategory?.id ?? '',
                              showRegular: true,
                              title: LocaleKeys.premiumRequest.localize);
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: _isButtonDisabled && _remainingTime != null
                              ? AppColors.GREY_DARK_COLOR
                              : AppColors.PRIMARY_COLOR,
                        ),
                        child: Center(
                            child: Text(
                          '${FormatNumbers().convertNumberToLocalizedString(((widget.trip.offerPriceRange?.lowestFare ?? 0) + (((widget.trip.offerPriceRange?.highestFare ?? 0) - (widget.trip.offerPriceRange?.lowestFare ?? 0)) * 1)).floor().toString(), isArabic: context.isArabic)} ${context.isArabic ? 'ج.م' : 'EGP'}',
                          textAlign: TextAlign.center,
                          style: Styles.mediumText(color: AppColors.whiteColor),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.onCancel != null) ...[
                SizedBox(
                  height: 4,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onCancel!(widget.trip);
                      // Handle confirm action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.SECONDARY_COLOR,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      context.isArabic ? 'اغلاق' : 'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStepperLine(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Stepper Line Container
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 6,
                child: const CircleAvatar(
                    backgroundColor: Colors.white, radius: 3),
              ),
              SizedBox(
                height: 4.h,
              ),
              ...List.generate(
                7,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? Colors.grey[600]
                        : Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              CircleAvatar(
                backgroundColor: Colors.green,
                radius: 6,
                child: const CircleAvatar(
                    backgroundColor: Colors.white, radius: 3),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
