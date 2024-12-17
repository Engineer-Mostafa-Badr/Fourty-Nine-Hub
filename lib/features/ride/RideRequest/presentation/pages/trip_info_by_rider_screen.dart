import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/dynamic_map_test.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_trip_from_driver_model/check_accept_trip_from_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/cancel_trip_client_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/partial_payment_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_reasons_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_trip_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/trip_info_by_driver_screen.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
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
                            showSuccessMessage(
                                context, LocaleKeys.successCancelTrip.tr());
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Sizer(
                      height: 48.h,
                    ),
                    const SizedBox(
                      height: 200,
                      child: DynamicMapWithPolyline(
                        polylineString: "",
                        // BlocProvider.of<GetTripInfoCubit>(context).polyLine,
                        useGoogleMaps: true,
                        url:
                            "https://maps.googleapis.com/maps/api/js?key=AIzaSyBBHEFa7D7qMSL4ivZhCqRQ4ok4sQN-Egc",
                        apiKey: "AIzaSyBBHEFa7D7qMSL4ivZhCqRQ4ok4sQN-Egc",
                      ),
                    ),
                    //
                    Column(
                      children: [
                        const Sizer(
                          height: 36,
                        ),
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
                              "${widget.model.fromTitle}",
                              style: Styles.mediumText(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            )),
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
                              "${widget.model.toTitle}",
                              style: Styles.mediumText(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ))
                          ],
                        ),
                        const Sizer(
                          height: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          width: double.infinity,
                          height: 46,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(226, 244, 255, 1),
                              borderRadius: BorderRadius.circular(13)),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: const Color(0xFF0E4669),
                              ),
                              const Sizer(),
                              Flexible(
                                child: Text(
                                  "${LocaleKeys.travelTime.tr()}: ~${formatDuration(widget.model.duration ?? 0)} , ${LocaleKeys.Distance.tr()}: ${formatDistance(widget.model.distance ?? 0)}",
                                  style: Styles.mediumText(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ),
                              const Sizer(),
                            ],
                          ),
                        ),
                        const Sizer(
                          height: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.isArabic
                                  ? "رمز التحقق المؤقت"
                                  : "Your OTP",
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 32,
                                  color: AppColors.DARK_GRAY_COLOR),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: (widget.model.otp ?? '')
                                  .split('')
                                  .map((char) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.PRIMARY_COLOR_DARK
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.PRIMARY_COLOR_DARK,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    char,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.PRIMARY_COLOR_DARK,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        const Sizer(
                          height: 30,
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Flexible(
                          child: AppButton(
                            width: double.infinity,
                            backColor: AppColors.PRIMARY_COLOR,
                            height: 80.h,
                            style: Styles.mediumText(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
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
                          child: AppButton(
                            width: double.infinity,
                            height: 80.h,
                            backColor: AppColors.PRIMARY_COLOR,
                            label: LocaleKeys.partialPayment.tr(),
                            style: Styles.mediumText(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
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
                                                .read<
                                                    PartialPaymentRiderCubit>()
                                                .partialPayment(
                                                    id: widget.model.id ?? "",
                                                    amount: double.parse(
                                                        amount.text),
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
                          child: AppButton(
                            backColor: AppColors.PRIMARY_COLOR_DARK,
                            height: 80.h,
                            width: double.infinity,
                            label: LocaleKeys.cancel.tr(),
                            style: Styles.headerText(color: Colors.white),
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
