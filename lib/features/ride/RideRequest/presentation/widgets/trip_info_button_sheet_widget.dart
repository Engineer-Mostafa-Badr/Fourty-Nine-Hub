import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/check_payment_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_trip_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/location_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/raise_fare_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/request_rider_trip_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/show_offers_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/ride_request_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class TripInfoButtonSheetWidget extends StatefulWidget {
  const TripInfoButtonSheetWidget({super.key, required this.model});
  final GetTripInfoModel model;
  @override
  State<TripInfoButtonSheetWidget> createState() =>
      _TripInfoButtonSheetWidgetState();
}

class _TripInfoButtonSheetWidgetState extends State<TripInfoButtonSheetWidget> {
  String paymentMethod = "cash";
  TextEditingController price = TextEditingController();
  @override
  void initState() {
    BlocProvider.of<GetCurrencyCubit>(context).getCurrencyData();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
    price.text = widget.model.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    var getTripInfoCubit = context.read<GetTripInfoCubit>();
    return Container(
      color: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 3.5)),
              ),
              const Sizer(),
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
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 3.5)),
              ),
              const Sizer(),
              Flexible(
                  child: Text(
                widget.model.to.toString(),
              ))
            ],
          ),
          const Sizer(),
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
                  setState(() {});
                },
              ),
            ],
          ),
          const Sizer(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.flash_on),
                    Text(
                      LocaleKeys.autoAccept.tr(),
                      style: Styles.mediumText(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Switch(
                      activeTrackColor: AppColors.PRIMARY_COLOR,
                      inactiveTrackColor: Colors.grey,
                      value: getTripInfoCubit.model.autoAccept ?? false,
                      onChanged: (value) {
                        getTripInfoCubit.autoAccept(value);
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
              const Sizer(),
              (getTripInfoCubit.model.autoAccept ?? false)
                  ? Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.PRIMARY_COLOR),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          Container(),
                          Container(
                            // height: 150,
                            // alignment: (getTripInfoCubit.model.autoAccept ?? false)
                            //     ? Alignment.center
                            //     : null,
                            margin: EdgeInsets.only(
                                top:
                                    (getTripInfoCubit.model.autoAccept ?? false)
                                        ? 0
                                        : 13,
                                left: 8,
                                right: 8),
                            child:
                                BlocBuilder<GetCurrencyCubit, GetCurrencyState>(
                              builder: (context, state) {
                                return BlocBuilder<GetCurrencyCubit,
                                    GetCurrencyState>(
                                  builder: (context, state) {
                                    return Text(
                                      "${context.isArabic ? BlocProvider.of<GetCurrencyCubit>(context).currnecyAr : BlocProvider.of<GetCurrencyCubit>(context).currnecyEn}${widget.model.price}",
                                      style: const TextStyle(
                                          color: AppColors.QUANTITY_COLOR,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.credit_card),
                              const Sizer(
                                width: 6,
                              ),
                              BlocListener<CheckPaymentCubit, RiderState>(
                                listener: (context, state) {
                                  log(state.toString(), name: "Payment");
                                  if (state is CashPaymentState) {
                                    setState(() {
                                      showErrorMessage(
                                          context,
                                          LocaleKeys.yourBalanceIsInsufficient
                                              .tr());
                                      paymentMethod = "cash";
                                    });
                                  }
                                  if (state is WalletPayemntState) {
                                    setState(() {
                                      paymentMethod = "wallet";
                                    });
                                  }
                                  if (state is FailureRiderState) {
                                    showErrorMessage(
                                        context,
                                        getFailureMessage(
                                            state.failure, context));
                                  }
                                },
                                child: DropdownButton(
                                  value: paymentMethod,
                                  dropdownColor: context.isDarkMode
                                      ? AppColors.QUANTITY_COLOR
                                      : Colors.white,
                                  icon: Container(),
                                  underline: Container(),
                                  onChanged: (value) {
                                    if (value == 'wallet') {
                                      context
                                          .read<CheckPaymentCubit>()
                                          .check(amount: price.text);
                                    } else {
                                      setState(() {
                                        paymentMethod = value!;
                                      });
                                    }
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      value: "cash",
                                      child: Text(LocaleKeys.Cash.tr()),
                                    ),
                                    DropdownMenuItem(
                                      value: "wallet",
                                      child: Text(LocaleKeys.wallet.tr()),
                                    ),
                                  ],
                                ),
                              ),
                              const Sizer()
                            ],
                          ),
                        ],
                      ),
                    )
                  : DefaultTextFormField(
                      currentController: price,
                      hint: LocaleKeys.offerYourFare.tr(),
                      readOnly: (getTripInfoCubit.model.autoAccept ?? false),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if ((double.tryParse(value.toString()) ?? 0) >
                            (widget.model.lowestFare ?? 0)) {
                          return "${LocaleKeys.MinimumFareIs.tr()} ${widget.model.lowestFare}";
                        }
                        return null;
                      },
                      hintColor: Colors.grey,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.credit_card),
                          const Sizer(
                            width: 6,
                          ),
                          BlocListener<CheckPaymentCubit, RiderState>(
                            listener: (context, state) {
                              log(state.toString(), name: "Payment");
                              if (state is CashPaymentState) {
                                setState(() {
                                  showErrorMessage(
                                      context,
                                      LocaleKeys.yourBalanceIsInsufficient
                                          .tr());
                                  paymentMethod = "cash";
                                });
                              }
                              if (state is WalletPayemntState) {
                                setState(() {
                                  paymentMethod = "wallet";
                                });
                              }
                              if (state is FailureRiderState) {
                                showErrorMessage(context,
                                    getFailureMessage(state.failure, context));
                              }
                            },
                            child: DropdownButton(
                              value: paymentMethod,
                              dropdownColor: context.isDarkMode
                                  ? AppColors.QUANTITY_COLOR
                                  : Colors.white,
                              icon: Container(),
                              underline: Container(),
                              onChanged: (value) {
                                if (value == 'wallet') {
                                  context
                                      .read<CheckPaymentCubit>()
                                      .check(amount: price.text);
                                } else {
                                  setState(() {
                                    paymentMethod = value!;
                                  });
                                }
                              },
                              items: [
                                DropdownMenuItem(
                                  value: "cash",
                                  child: Text(LocaleKeys.Cash.tr()),
                                ),
                                DropdownMenuItem(
                                  value: "wallet",
                                  child: Text(LocaleKeys.wallet.tr()),
                                ),
                              ],
                            ),
                          ),
                          const Sizer()
                        ],
                      ),
                      prefixIcon: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top:
                                    (getTripInfoCubit.model.autoAccept ?? false)
                                        ? 0
                                        : 13,
                                left: 8,
                                right: 8),
                            child:
                                BlocBuilder<GetCurrencyCubit, GetCurrencyState>(
                              builder: (context, state) {
                                return Text(
                                  "${context.isArabic ? BlocProvider.of<GetCurrencyCubit>(context).currnecyAr : BlocProvider.of<GetCurrencyCubit>(context).currnecyEn}${widget.model.price}",
                                  style: const TextStyle(
                                      color: AppColors.QUANTITY_COLOR,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
              const Sizer(),
              Container(
                // padding:
                // EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                height: 46,
                decoration: BoxDecoration(
                    // color: Color(0xFF0E4669),
                    borderRadius: BorderRadius.circular(13)),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    ),
                    const Sizer(),
                    Flexible(
                      child: Text(
                        "${LocaleKeys.travelTime.tr()}: ~${formatDuration(widget.model.duration!.toInt())} , ${LocaleKeys.Distance.tr()}: ${formatDistance(widget.model.distance!.toInt())}",
                        style: Styles.mediumText(
                          fontWeight: FontWeight.w500,
                          color:
                              context.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const Sizer(),
                  ],
                ),
              ),
            ],
          ),
          const Sizer(),
          Row(
            children: [
              Flexible(
                child: AppButton(
                  height: 40,
                  label: LocaleKeys.premuimRequest.tr(),
                  style: Styles.headerText(color: Colors.white),
                  onPressed: () {
                    context.read<RequestRiderTripCubit>().request(
                        model: TripRequestModel(
                            autoAccept:
                                getTripInfoCubit.model.autoAccept ?? false,
                            comfort: getTripInfoCubit.model.comfort ?? false,
                            calculateB: widget.model.calculateB,
                            distance: widget.model.distance,
                            duration: widget.model.duration,
                            fromTitle: widget.model.from,
                            isPremium: true,
                            passengers: 4,
                            paymentMethod: "cash",
                            price: double.parse(price.text),
                            startLocation: widget.model.startLocation,
                            targetLocation: widget.model.targetLocation,
                            toTitle: widget.model.to));
                  },
                ),
              ),
              // const Gap(6),
              const SizedBox(width: 6),
              BlocConsumer<RequestRiderTripCubit, RiderState>(
                listener: (context, state) async {
                  log(state.toString(), name: "ldsjflskdjflskdfjlskjf");
                  if (state is SuccessRequestTripState) {
                    context.read<ShowOffersCubit>().showOffers();
                    // context.read<LocationSocketCubit>().nearbyDriversEmit(
                    //     tripId: state.model.trip?.id ?? "",
                    //     location:صw
                    //         state.model.trip?.riderLocation?.coordinates ?? [],
                    //     subcategoryId: state.model.trip?.subCategoryId ?? "");
                    await BlocProvider.of<GetCurrencyCubit>(context)
                        .getCurrencyData();

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
                                maxHeight: MediaQuery.of(context).size.height *
                                    0.95, // Adjust height
                              ),
                              child: BlocProvider(
                                create: (context) =>
                                    GetCurrencyCubit(serviceLocator()),
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
                        context.read<RequestRiderTripCubit>().request(
                            model: TripRequestModel(
                                autoAccept:
                                    getTripInfoCubit.model.autoAccept ?? false,
                                comfort:
                                    getTripInfoCubit.model.comfort ?? false,
                                calculateB: widget.model.calculateB,
                                distance: widget.model.distance,
                                duration: widget.model.duration,
                                fromTitle: widget.model.from,
                                isPremium: false,
                                passengers: 4,
                                paymentMethod: paymentMethod,
                                price: double.parse(price.text),
                                startLocation: widget.model.startLocation,
                                targetLocation: widget.model.targetLocation,
                                toTitle: widget.model.to));
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
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
