import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/check_payment_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_trip_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/raise_fare_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/request_rider_trip_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/show_offers_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/ride_request_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

class TripInfoButtonSheetWidget extends StatefulWidget {
  const TripInfoButtonSheetWidget({super.key, required this.model});
  final GetTripInfoModel model;
  @override
  State<TripInfoButtonSheetWidget> createState() =>
      _TripInfoButtonSheetWidgetState();
}

class _TripInfoButtonSheetWidgetState extends State<TripInfoButtonSheetWidget> {
  String paymentMethod = "cash";
  int farePrice = 0;
  final _formKey = GlobalKey<FormState>();

  TextEditingController price = TextEditingController();
  @override
  void initState() {
    BlocProvider.of<GetCurrencyCubit>(context).getCurrencyData();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
    // price.text = widget.model.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    var getTripInfoCubit = context.read<GetTripInfoCubit>();
    return Container(
        height: MediaQuery.of(context).size.height,
        color: context.isDarkMode
            ? AppColors.QUANTITY_COLOR
            : AppColors.LIGHT_GRAY_COLOR,
        padding: const EdgeInsets.symmetric(),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Sizer(
              height: 24.h,
            ),
            Container(
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? AppColors.QUANTITY_COLOR
                    : Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 4, top: 20, left: 16, right: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              size: 30,
                              weight: 2,
                            ),
                          ),
                          const Spacer(
                            flex: 3,
                          ),
                          Text(
                            context.isArabic ? "قدم عرضك" : "Offer your fare",
                            style: Styles.mediumText(
                                fontSize: 34, fontWeight: FontWeight.w600),
                          ),
                          const Spacer(
                            flex: 4,
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<GetCurrencyCubit, GetCurrencyState>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: price,
                                    decoration: InputDecoration(
                                      focusColor: context.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      errorText: context.isArabic
                                          ? "الأجرة الموصى بها هي ${BlocProvider.of<GetCurrencyCubit>(context).currnecyAr}${widget.model.price?.toInt()}"
                                          : "Recommended fare is ${BlocProvider.of<GetCurrencyCubit>(context).currnecyEn}${(getTripInfoCubit.model.comfort ?? false) ? ((widget.model.comfort ?? 0) + (widget.model.price ?? 0)) : widget.model.price?.toInt()}",
                                      focusedErrorBorder:
                                          const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.LIGHT_GRAY_COLOR),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 4), // Add 4 padding from top
                                      errorStyle: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: AppColors.PRIMARY_COLOR_DARK),
                                      fillColor: Colors.transparent,
                                      border: const UnderlineInputBorder(),

                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.LIGHT_GRAY_COLOR),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.LIGHT_GRAY_COLOR),
                                      ),
                                      errorBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.LIGHT_GRAY_COLOR),
                                      ),
                                      disabledBorder:
                                          const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.LIGHT_GRAY_COLOR),
                                      ),
                                      prefixIcon: Column(
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  top: 8, right: 4),
                                              child: Text(
                                                context.isArabic
                                                    ? BlocProvider.of<
                                                                GetCurrencyCubit>(
                                                            context)
                                                        .currnecyAr
                                                    : BlocProvider.of<
                                                                GetCurrencyCubit>(
                                                            context)
                                                        .currnecyEn,
                                                style: Styles.headerText(
                                                    color: context.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 90),
                                              )),
                                        ],
                                      ),
                                    ),
                                    cursorColor: context.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    style: Styles.headerText(
                                        color: context.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 90),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      farePrice = int.tryParse(value) ?? 0;
                                    },
                                    validator: (value) {
                                      if (value == "" || value == null) {
                                        return context.isArabic
                                            ? "يرجى ملء هذا الحقل"
                                            : "Please fill in this field";
                                      }
                                      log(widget.model.lowestFare.toString(),
                                          name: "lskdjflskjdlksjdf");
                                      if ((double.tryParse(value.toString()) ??
                                              0) <
                                          (widget.model.lowestFare ?? 0)) {
                                        return "${LocaleKeys.MinimumFareIs.tr()} ${context.isArabic ? BlocProvider.of<GetCurrencyCubit>(context).currnecyAr : BlocProvider.of<GetCurrencyCubit>(context).currnecyEn}${widget.model.lowestFare}";
                                      }
                                      return null;
                                    },
                                    cursorErrorColor: context.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Sizer(
              height: 8,
            ),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? AppColors.QUANTITY_COLOR
                      : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 4,
                  ),
                  child: Column(
                    children: [
                      const Sizer(),
                      Row(
                        children: [
                          BlocListener<CheckPaymentCubit, RiderState>(
                            listener: (context, state) {
                              log(state.toString(), name: "Payment");

                              if (state is CashPaymentState) {
                                setState(() {
                                  paymentMethod = "cash";
                                });
                                showSuccessDialog(
                                  context,
                                  LocaleKeys.yourBalanceIsInsufficient.tr(),
                                );
                              }
                              if (state is WalletPayemntState) {
                                setState(() {
                                  paymentMethod = "wallet";
                                });
                              } else if (state is FailureRiderState) {
                                showErrorMessage(
                                  context,
                                  getFailureMessage(state.failure, context),
                                );
                              }
                            },
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                  ),
                                  builder: (context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: context.isDarkMode
                                              ? AppColors.QUANTITY_COLOR
                                              : Colors.white,
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(16),
                                              topLeft: Radius.circular(16))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 16,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    context.isArabic
                                                        ? "أساليب الدفع"
                                                        : "Payment methods",
                                                    style: Styles.headerText(),
                                                  ),
                                                  const Spacer(),
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Icon(
                                                          Icons.close))
                                                ],
                                              ),
                                            ),
                                            const Sizer(
                                              height: 24,
                                            ),
                                            Container(
                                              color: paymentMethod == "cash"
                                                  ? const Color.fromRGBO(
                                                      226, 244, 255, 1)
                                                  : Colors.transparent,
                                              child: ListTile(
                                                leading: const Icon(
                                                    Icons.attach_money),
                                                title: Text(
                                                  LocaleKeys.Cash.tr(),
                                                  style: Styles.mediumText(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                trailing: paymentMethod ==
                                                        "cash"
                                                    ? const Icon(Icons.check,
                                                        size: 28,
                                                        color: Color.fromRGBO(
                                                            64, 135, 225, 1))
                                                    : null,
                                                onTap: () {
                                                  setState(() {
                                                    paymentMethod = "cash";
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                            Container(
                                              color: paymentMethod == "wallet"
                                                  ? const Color.fromRGBO(
                                                      226, 244, 255, 1)
                                                  : Colors.transparent,
                                              child: ListTile(
                                                leading: const Icon(
                                                    Icons.credit_card),
                                                title: Text(
                                                  LocaleKeys.wallet.tr(),
                                                  style: Styles.mediumText(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                trailing: paymentMethod ==
                                                        "wallet"
                                                    ? const Icon(Icons.check,
                                                        size: 28,
                                                        color: Color.fromRGBO(
                                                            64, 135, 225, 1))
                                                    : null, // Checkmark for selected item
                                                onTap: () {
                                                  context
                                                      .read<CheckPaymentCubit>()
                                                      .check(
                                                          amount:
                                                              price.text.isEmpty
                                                                  ? "0"
                                                                  : price.text);
                                                  setState(() {
                                                    paymentMethod = "wallet";
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 32,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16, bottom: 16),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        paymentMethod == "cash"
                                            ? Icons.attach_money
                                            : Icons.credit_card,
                                      ),
                                      const SizedBox(width: 8),
                                      BlocBuilder<CheckPaymentCubit,
                                          RiderState>(
                                        builder: (context, state) {
                                          return Text(
                                            paymentMethod == "cash"
                                                ? LocaleKeys.Cash.tr()
                                                : LocaleKeys.wallet.tr(),
                                            style: Styles.mediumText(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w500),
                                          );
                                        },
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.record.tr(),
                            style: const TextStyle(fontSize: 17),
                          ),
                          Switch(
                            activeTrackColor: AppColors.PRIMARY_COLOR,
                            inactiveTrackColor: Colors.grey,
                            value: getTripInfoCubit.record,
                            onChanged: (value) {
                              getTripInfoCubit.recordChange(value);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      const Sizer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.comfort.tr(),
                            style: const TextStyle(fontSize: 17),
                          ),
                          Switch(
                            activeTrackColor: AppColors.PRIMARY_COLOR,
                            inactiveTrackColor: Colors.grey,
                            value: getTripInfoCubit.model.comfort ?? false,
                            onChanged: (value) {
                              getTripInfoCubit.comfort(value);
                              if (value) {
                                price.text = (double.parse(price.text) +
                                        (widget.model.comfort ?? 0))
                                    .toStringAsFixed(0);
                              } else {
                                price.text = (double.parse(price.text) -
                                        (widget.model.comfort ?? 0))
                                    .toStringAsFixed(0);
                              }
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      const Sizer(),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Row(
                              children: [
                                const Icon(Icons.flash_on),
                                Text(
                                  LocaleKeys.autoAccept.tr(),
                                  style: Styles.mediumText(
                                      fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                Switch(
                                  activeTrackColor: AppColors.PRIMARY_COLOR,
                                  inactiveTrackColor: Colors.grey,
                                  value: getTripInfoCubit.model.autoAccept ??
                                      false,
                                  onChanged: (value) {
                                    getTripInfoCubit.autoAccept(value);
                                    setState(() {});
                                  },
                                )
                              ],
                            ),
                          ),
                          const Sizer(),
                          const Sizer(),
                          Row(
                            children: [
                              Text(
                                context.isArabic
                                    ? "رحلتك الحالية"
                                    : "Your current ride",
                                style: Styles.mediumText(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 32,
                                    color: AppColors.DARK_GRAY_COLOR),
                              ),
                              const Spacer()
                            ],
                          ),
                          const Sizer(),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color:
                                            const Color.fromRGBO(6, 147, 45, 1),
                                        width: 5)),
                              ),
                              const Sizer(
                                width: 24,
                              ),
                              Flexible(
                                  child: Text(
                                widget.model.from.toString(),
                              ))
                            ],
                          ),
                          const Sizer(),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            255, 132, 125, 1),
                                        width: 5)),
                              ),
                              const Sizer(
                                width: 24,
                              ),
                              Flexible(
                                  child: Text(
                                widget.model.to.toString(),
                              ))
                            ],
                          ),
                        ],
                      ),
                      const Sizer(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                border: Border.all(
                                    color: Colors.transparent, width: 1.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _launchCall('122');
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: context.isDarkMode
                                              ? AppColors.QUANTITY_COLOR
                                              : Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 24),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.call,
                                                color: context.isDarkMode
                                                    ? AppColors.GREY_LIGHT_COLOR
                                                    : const Color.fromARGB(
                                                        255, 106, 106, 109),
                                                size: 30,
                                              ),
                                              const Sizer(
                                                width: 36,
                                              ),
                                              Text(
                                                "${LocaleKeys.call.localize} 122",
                                                style: Styles.headerText(
                                                    color: AppColors
                                                        .PRIMARY_COLOR_DARK),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 8), // Transparent space
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: context.isDarkMode
                                              ? AppColors.QUANTITY_COLOR
                                              : Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 24),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                LocaleKeys.cancel.localize,
                                                style: Styles.headerText(
                                                    color: AppColors
                                                        .PRIMARY_COLOR_DARK),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.local_police_outlined,
                                size: 28,
                                color: AppColors.PRIMARY_COLOR_DARK,
                              ),
                              const Sizer(),
                              Text(
                                context.isArabic
                                    ? "الاتصال بالطوارئ"
                                    : "Call emergency",
                                style: Styles.headerText(
                                    color: AppColors.PRIMARY_COLOR_DARK,
                                    fontSize: 34),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Sizer(
                        height: 36,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: AppButton(
                              height: 40,
                              label: LocaleKeys.premuimRequest.tr(),
                              style: Styles.headerText(color: Colors.white),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  context.read<RequestRiderTripCubit>().request(
                                        model: TripRequestModel(
                                          autoAccept: getTripInfoCubit
                                                  .model.autoAccept ??
                                              false,
                                          comfort:
                                              getTripInfoCubit.model.comfort ??
                                                  false,
                                          calculateB: widget.model.calculateB,
                                          distance: widget.model.distance,
                                          duration: widget.model.duration,
                                          fromTitle: widget.model.from,
                                          isPremium: true,
                                          passengers: 4,
                                          paymentMethod: "cash",
                                          price: double.parse(price
                                              .text), // Use controller text
                                          startLocation:
                                              widget.model.startLocation,
                                          targetLocation:
                                              widget.model.targetLocation,
                                          toTitle: widget.model.to,
                                        ),
                                      );
                                } else {
                                  print('Form is invalid');
                                }
                              },
                            ),
                          ),
                          // const Gap(6),
                          const SizedBox(width: 6),
                          BlocConsumer<RequestRiderTripCubit, RiderState>(
                            listener: (context, state) async {
                              log(state.toString(),
                                  name: "ldsjflskdjflskdfjlskjf");
                              if (state is SuccessRequestTripState) {
                                context.read<ShowOffersCubit>().showOffers();
                                // context.read<LocationSocketCubit>().nearbyDriversEmit(
                                //     tripId: state.model.trip?.id ?? "",
                                //     location:صw
                                //         state.model.trip?.riderLocation?.coordinates ?? [],
                                //     subcategoryId: state.model.trip?.subCategoryId ?? "");
                                // await BlocProvider.of<GetCurrencyCubit>(context)
                                //     .getCurrencyData();
                                showModalBottomSheet(
                                  context: context,
                                  isDismissible:
                                      false, // Prevent dismissing by tapping outside
                                  enableDrag: false, // Prevent drag to dismiss
                                  isScrollControlled:
                                      true, // Allow full-screen height if needed
                                  builder: (context) {
                                    return GestureDetector(
                                      onVerticalDragStart:
                                          (_) {}, // Disable manual drag gestures
                                      child: BlocProvider(
                                        create: (context) => RaiseFareCubit(
                                          repository: serviceLocator(),
                                        ),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.95, // Adjust height
                                          ),
                                          child: BlocProvider(
                                            create: (context) =>
                                                GetCurrencyCubit(
                                                    serviceLocator()),
                                            child: RequestButtonSheetWidget(
                                              model: state.model,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            builder: (context, state) {
                              log(state.toString(),
                                  name: "lskdddddddddddddddddddddddddddd");
                              return Flexible(
                                child: AppButton(
                                  height: 40,
                                  backColor: const Color(0xFF0B1135),
                                  label: LocaleKeys.request.tr(),
                                  style: Styles.headerText(color: Colors.white),
                                  onPressed: () async {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      context
                                          .read<RequestRiderTripCubit>()
                                          .request(
                                              model: TripRequestModel(
                                                  autoAccept: getTripInfoCubit
                                                          .model.autoAccept ??
                                                      false,
                                                  comfort: getTripInfoCubit
                                                          .model.comfort ??
                                                      false,
                                                  calculateB:
                                                      widget.model.calculateB,
                                                  distance:
                                                      widget.model.distance,
                                                  duration:
                                                      widget.model.duration,
                                                  fromTitle: widget.model.from,
                                                  isPremium: false,
                                                  passengers: 4,
                                                  paymentMethod: paymentMethod,
                                                  price:
                                                      double.parse(price.text),
                                                  startLocation: widget
                                                      .model.startLocation,
                                                  targetLocation: widget
                                                      .model.targetLocation,
                                                  toTitle: widget.model.to));
                                    } else {
                                      // Show an error message or handle invalid form
                                      print('Form is invalid');
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const Sizer(
                        height: 36,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ));
  }

  void _launchCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  String formatDuration(int totalSeconds) {
    if (totalSeconds >= 3600) {
      // إذا كان العدد يساوي أو أكبر من ساعة (3600 ثانية)
      int hours = totalSeconds ~/ 3600;
      int minutes = (totalSeconds % 3600) ~/ 60;
      return '$hours h, $minutes min';
    } else if (totalSeconds >= 60) {
      // إذا كان العدد يساوي أو أكبر من دقيقة (60 ثانية)
      int minutes = totalSeconds ~/ 60;
      int seconds = totalSeconds % 60;
      return '$minutes min, $seconds s';
    } else {
      // إذا كان العدد أقل من دقيقة
      return '$totalSeconds s';
    }
  }

  String formatDistance(int meters) {
    if (meters >= 1000) {
      // تحويل الأمتار إلى كيلومترات
      double kilometers = meters / 1000;
      return '${kilometers.toStringAsFixed(2)} km';
    } else {
      // إذا كان العدد أقل من 1000 متر
      return '$meters m';
    }
  }
}
