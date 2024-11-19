import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_trip_from_driver_model/check_accept_trip_from_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/cancel_trip_client_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/partial_payment_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_reasons_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/trip_info_by_driver_screen.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class TripInfoByRiderScreen extends StatefulWidget {
  const TripInfoByRiderScreen({super.key, required this.model});
  final CheckAcceptTripFromDriverModel model;

  @override
  State<TripInfoByRiderScreen> createState() => _TripInfoByRiderScreenState();
}

class _TripInfoByRiderScreenState extends State<TripInfoByRiderScreen> {
  TextEditingController amount = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amount.text = widget.model.price.toString();
    saveData();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  saveData() {
    CacheService cacheService = CacheServiceImpl();
    cacheService.saveRiderTripInfo(model: widget.model);
  }

  removeData() {
    CacheService cacheService = CacheServiceImpl();
    cacheService.removeRiderTripInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: BlocListener<PartialPaymentRiderCubit, RiderState>(
        listener: (context, state) {
          if (state is SuccessPartialPaymentState) {
            showSuccessMessage(context, LocaleKeys.successSubmit.tr());
          }
          if (state is FailureRiderState) {
            showErrorMessage(
                context, getFailureMessage(state.failure, context));
          }
        },
        child: BlocListener<CancelTripClientCubit, RiderState>(
          listener: (context, state) {
            log(state.toString(), name: "lkdjslkdfjslkdjflskdjf");
            if (state is SuccessCancelTripClientState) {
              removeData();
              showSuccessDialog(context, LocaleKeys.successCancelTrip.tr());
              context.pushAndRemoveUntil(
                Routes.HOME,
                (route) => false,
              );
            }
            if (state is FailureRiderState) {
              showErrorMessage(
                  context, getFailureMessage(state.failure, context));
            }
          },
          child: BlocListener<GetReasonsCubit, RiderState>(
            listener: (context, state) {
              if (state is SuccessGetResonsState) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: BlocListener<CancelTripClientCubit, RiderState>(
                        listener: (context, state) {
                          log(state.toString(), name: "lkdjslkdfjslkdjflskdjf");
                          if (state is SuccessCancelTripClientState) {
                            removeData();
                            showSuccessMessage(context, LocaleKeys.successCancelTrip.tr());
                            context.pop();
                            context.pushReplacement(
                              Routes.RIDE,
                            );
                          }
                          if (state is FailureRiderState) {
                            showErrorMessage(context,
                                getFailureMessage(state.failure, context));
                          }
                        },
                        child: ReasonsDilogWidget(
                          list: state.list,
                          onTap: (reasonsId) {
                            log("slkdjflskdjlsdkjf",
                                name: reasonsId.toString());
                            context
                                .read<CancelTripClientCubit>()
                                .cancelTripClient(
                                  id: widget.model.id ?? "",
                                  reasonId: reasonsId,
                                  note: '',
                                );
                          },
                        ),
                      ),
                    );
                  },
                );
              }
              if (state is FailureRiderState) {
                showErrorMessage(
                    context, getFailureMessage(state.failure, context));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const Spacer(),
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.blue, width: 3)),
                          ),
                          const Sizer(),
                          Flexible(child: Text("${widget.model.toTitle}"))
                        ],
                      ),
                      const Sizer(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.green, width: 3)),
                          ),
                          const Sizer(),
                          Flexible(child: Text("${widget.model.fromTitle}")),
                        ],
                      ),
                      const Sizer(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                              "${LocaleKeys.travelTime.tr()}: ${formatDuration(widget.model.duration ?? 0)}"),
                        ],
                      ),
                      const Sizer(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                              "${LocaleKeys.destination.tr()}: ${formatDistance(widget.model.distance ?? 0)}"),
                        ],
                      ),
                      const Sizer(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text("OTP: ${widget.model.otp}"),
                        ],
                      )
                    ],
                  ),
                  // Spacer(),
                  const Sizer(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: DefaultButton(
                          padding: EdgeInsets.zero,
                          width: double.infinity,
                          label: LocaleKeys.openGoogleMap.tr(),
                          onPressed: () {
                            openGoogleMaps(
                                lat: widget
                                    .model.targetLocation!.coordinates![0],
                                lng: widget
                                    .model.targetLocation!.coordinates![1]);
                          },
                        ),
                      ),
                      const Sizer(),
                      Flexible(
                        child: DefaultButton(
                          padding: EdgeInsets.zero,
                          width: double.infinity,
                          label: LocaleKeys.partialPayment.tr(),
                          onPressed: () {
                            scaffoldKey.currentState?.showBottomSheet(
                              (context) {
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 80),
                                      ],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30))),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DefaultTextFormField(
                                        currentController: amount,
                                        hint: "",
                                      ),
                                      const Sizer(
                                        height: 40,
                                      ),
                                      DefaultButton(
                                        padding: EdgeInsets.zero,
                                        width: double.infinity,
                                        onPressed: () {
                                          context
                                              .read<PartialPaymentRiderCubit>()
                                              .partialPayment(
                                                  id: widget.model.id ?? "",
                                                  amount:
                                                      double.parse(amount.text),
                                                  paymentMethod: 'cash');
                                        },
                                        label: LocaleKeys.submit.tr(),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Flexible(
                        child: DefaultButton(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.zero,
                          width: double.infinity,
                          label: LocaleKeys.cancel.tr(),
                          onPressed: () {
                            context.read<GetReasonsCubit>().get();
                          },
                        ),
                      ),
                    ],
                  ),
                  const Sizer()
                ],
              ),
            ),
          ),
        ),
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
      // int seconds = totalSeconds % 60;
      return '$minutes min';
    } else {
      // إذا كان العدد أقل من دقيقة
      return '$totalSeconds s';
    }
  }

// , $seconds s
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

  void openGoogleMaps({
    required double lat,
    required double lng,
  }) async {
    log("geo::$lat,$lng");
    // رابط تطبيق خرائط جوجل
    final googleMapsAppUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    log(googleMapsAppUrl);
    // رابط خرائط جوجل عبر المتصفح
    // final googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&origin=$startLat,$startLng&destination=$endLat,$endLng&travelmode=driving';

    // محاولة فتح تطبيق خرائط جوجل
    if (await canLaunch(googleMapsAppUrl)) {
      await launch(googleMapsAppUrl);
    } else if (await canLaunch(googleMapsAppUrl)) {
      // إذا لم يكن التطبيق متاحاً، يتم فتح الرابط عبر المتصفح
      await launch(googleMapsAppUrl);
    } else {
      throw 'Could not launch Google Maps.';
    }
  }
}
