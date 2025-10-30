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
      {super.key, required this.trip, required this.params, this.onCancel, required this.showRemoveButton});
  final AvailableTripEntity trip;
  final bool showRemoveButton;
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
  String formatDuration(BuildContext context, int minutes) {
    String numberToLocale(int number) {
      if (!context.isArabic) return number.toString();

      const arabicDigits = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
      return number
          .toString()
          .split('')
          .map((char) =>
      int.tryParse(char) != null ? arabicDigits[int.parse(char)] : char)
          .join();
    }

    if (minutes < 0) return context.isArabic ? 'غير صالح' : 'Invalid';

    if (minutes < 60) {
      return context.isArabic
          ? '${numberToLocale(minutes)} د'
          : '$minutes m';
    } else if (minutes < 1440) {
      int hours = (minutes / 60).floor();
      return context.isArabic
          ? '${numberToLocale(hours)} س'
          : '$hours h';
    } else if (minutes < 10080) {
      int days = (minutes / 1440).floor();
      return context.isArabic
          ? '${numberToLocale(days)} يوم'
          : '$days d';
    } else {
      int weeks = (minutes / 10080).floor();
      return context.isArabic
          ? '${numberToLocale(weeks)} أسبوع'
          : '$weeks w';
    }
  }

  String formatDistance(BuildContext context, num meters) {
    // دالة لتحويل الأرقام حسب اللغة
    String numberToLocale(String input) {
      if (!context.isArabic) return input;

      const arabicDigits = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
      return input
          .split('')
          .map((char) =>
      int.tryParse(char) != null ? arabicDigits[int.parse(char)] : char)
          .join();
    }

    if (meters < 0) return context.isArabic ? 'غير صالح' : 'Invalid';

    if (meters < 1000) {
      int rounded = meters.round();
      return context.isArabic
          ? '${numberToLocale(rounded.toString())} م'
          : '$rounded m';
    } else {
      double km = meters / 1000;
      String formatted = km.toStringAsFixed(km < 10 ? 1 : 0); // مثال: 1.5 كم
      return context.isArabic
          ? '${numberToLocale(formatted)} كم'
          : '$formatted km';
    }
  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardsCubit, DashboardsState>(
        builder: (context, state) {
      var cubit = context.read<DashboardsCubit>();
      num highRange = ((widget.trip.price ?? 0) + (((widget.trip.offerPriceRange?.highestFare ?? 0) - (widget.trip.offerPriceRange?.lowestFare ?? 0)) * 1)).floor();
      bool enableIncrement = ((widget.trip.lastOffer ?? 0) + 3 )>highRange;
      num offer = enableIncrement
          ? highRange
          : (widget.trip.lastOffer ?? 0);
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
                            Baseline(
                              baselineType: TextBaseline.alphabetic,
                              baseline: context.isArabic ? 20 : 30,
                              child: Text(
                                ' ${context.isArabic ? widget.trip.paymentMethod=='cash'?'(نقدا)':'(فيزا)' : widget.trip.paymentMethod=='cash'?'(Cash)':'(Visa)'}',
                                style: const TextStyle(
                                  fontSize: 16,
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
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                context.isArabic
                                    ? 'على بعد ${formatDuration(context,(widget.trip.route?.driverPosition?.durationToPickup??0).toInt())} - ( ${formatDistance(context, widget.trip.route?.driverPosition?.distanceToPickup ?? 0)} )'
                                    : '${formatDuration(context,(widget.trip.route?.driverPosition?.durationToPickup??0).toInt())} min - ( ${formatDistance(context, widget.trip.route?.driverPosition?.distanceToPickup ?? 0)} ) away',
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
                              ? 'مشوار لمدة ${formatDuration(context,(widget.trip.route?.dropPoint?.durationFromPickup??0).toInt())} - المسافة ${"( ${formatDistance(context, widget.trip.route?.dropPoint?.distanceFromPickup ?? 0)}"} )'
                              : '${formatDuration(context,(widget.trip.route?.dropPoint?.durationFromPickup??0).toInt())} walk - distance ( ${formatDistance(context, widget.trip.route?.dropPoint?.distanceFromPickup ?? 0)} )',
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
                  if(widget.trip.isAutoAccept !=true)ClickableWidget(
                    onTap: () {
                      num range = ((widget.trip.price ?? 0) + (((widget.trip.offerPriceRange?.highestFare ?? 0) - (widget.trip.offerPriceRange?.lowestFare ?? 0)) * 1)).floor();

                          // (widget.trip.price??0).floor() + ((widget.trip.offerPriceRange?.highestFare??0).floor()-(widget.trip.offerPriceRange?.lowestFare??0).floor());
                      bool notAvailable= ((widget.trip.lastOffer??0)+3)>range;
                      // ManageVibration.vibrate();
                      // widget.trip.lastOffer =
                      // ((widget.trip.lastOffer ??
                      //     0)
                      //     .ceil() +
                      //     3);
                      // setState(() {});
                      // print("widget.trip.lastOffer ${widget.trip.lastOffer}");
                      if (_isButtonDisabled || notAvailable ) {
                        widget.trip.lastOffer = range;
                        setState(() {});
                        return;
                      }
                      ManageVibration.vibrate();
                      widget.trip.lastOffer =
                      ((widget.trip.lastOffer ??
                          0)
                          .ceil() +
                          3);
                      setState(() {});
                      return;
                      // if (_isButtonDisabled ||
                      //     ((widget.trip.lastOffer ?? 0) + 3 >
                      //         ((widget.trip.price??0)+((widget.trip.offerPriceRange?.highestFare ?? 0)-(widget.trip.offerPriceRange?.highestFare ?? 0))))) {
                      //   widget.trip.lastOffer = ((widget.trip.price??0)+((widget.trip.offerPriceRange?.highestFare ?? 0)-(widget.trip.offerPriceRange?.highestFare ?? 0))+(widget.trip.price??0)).floor();
                      //   return;
                      // }

                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: ((_isButtonDisabled && _remainingTime != null )|| enableIncrement
                        )
                            ? AppColors.GREY_DARK_COLOR
                            : AppColors.PRIMARY_COLOR,
                      ),
                      child: Text(
                        '+${FormatNumbers().convertNumberToLocalizedString('3', isArabic: context.isArabic)}',
                        style: Styles.mediumText(
                            color: AppColors.whiteColor, fontSize: 32),
                      ),
                    ),
                  ),
                  if(widget.trip.isAutoAccept !=true)Sizer(width: 8),
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
                                ? 'القبول مقابل ${FormatNumbers().convertNumberToLocalizedString(widget.trip.isAutoAccept == true?(widget.trip.price??0).ceil().toString():offer.floor().toString(), isArabic: context.isArabic)} ج.م'
                                : 'Accept for ${FormatNumbers().convertNumberToLocalizedString(offer.floor().toString(), isArabic: context.isArabic)} EGP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )),
                  if(widget.trip.isAutoAccept !=true)Sizer(width: 8),
                  if(widget.trip.isAutoAccept !=true)ClickableWidget(
                    onTap: () {
                      if (_isButtonDisabled ||
                          (((widget.trip.lastOffer ?? 0) - 3) <
                              (widget.trip.price ?? 0))) {
                        widget.trip.lastOffer = widget.trip.price;
                        setState(() {});
                        return;
                      }
                      ManageVibration.vibrate();
                      widget.trip.lastOffer =
                      ((widget.trip.lastOffer ??
                          0)
                          .ceil() -
                          3);
                      setState(() {});
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: (_isButtonDisabled && _remainingTime != null ||
                                ((widget.trip.lastOffer ?? 0)
                                    .ceil() ==
                                    (widget.trip.price ??
                                            0)
                                        .floor()))
                            ? AppColors.GREY_DARK_COLOR
                            : AppColors.PRIMARY_COLOR,
                      ),
                      child: Text(
                        '-${FormatNumbers().convertNumberToLocalizedString('3', isArabic: context.isArabic)}',
                        style: Styles.mediumText(
                            color: AppColors.whiteColor, fontSize: 32),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              if(widget.trip.isAutoAccept !=true)Row(
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
                                    ((widget.trip.price ??
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
                                  widget.trip.lastOffer = ((widget
                                                  .trip
                                                  .price ??
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
                          '${FormatNumbers().convertNumberToLocalizedString(((widget.trip.price ?? 0).ceil() + (((widget.trip.offerPriceRange?.highestFare ?? 0) - (widget.trip.offerPriceRange?.lowestFare ?? 0)) * 0.2)).ceil().toString(), isArabic: context.isArabic)} ${context.isArabic ? 'ج.م' : 'EGP'}',
                          textAlign: TextAlign.center,
                              style: Styles.mediumText(color: AppColors.whiteColor,fontSize: 32),
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
                                    ((widget.trip.price ??
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
                                  widget.trip.lastOffer = ((widget
                                                  .trip
                                                  .price ??
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
                          '${FormatNumbers().convertNumberToLocalizedString(((widget.trip.price ?? 0).ceil() + (((widget.trip.offerPriceRange?.highestFare ?? 0) - (widget.trip.offerPriceRange?.lowestFare ?? 0)) * 0.5)).ceil().toString(), isArabic: context.isArabic)} ${context.isArabic ? 'ج.م' : 'EGP'}',
                          textAlign: TextAlign.center,
                          style: Styles.mediumText(color: AppColors.whiteColor,fontSize: 32),
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
                                    ((widget.trip.price ??
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
                                  widget.trip.lastOffer =
                                      ((widget.trip.price ??
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
                          '${FormatNumbers().convertNumberToLocalizedString(((widget.trip.price ?? 0) + (((widget.trip.offerPriceRange?.highestFare ?? 0) - (widget.trip.offerPriceRange?.lowestFare ?? 0)) * 1)).floor().toString(), isArabic: context.isArabic)} ${context.isArabic ? 'ج.م' : 'EGP'}',
                          textAlign: TextAlign.center,
                              style: Styles.mediumText(color: AppColors.whiteColor,fontSize: 32),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.showRemoveButton) ...[
                SizedBox(
                  height: 4,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onCancel==null?(){}:widget.onCancel!(widget.trip);
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
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
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
