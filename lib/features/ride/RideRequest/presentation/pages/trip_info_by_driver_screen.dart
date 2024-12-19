import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/dynamic_map_test.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_by_rider_model/check_accept_by_rider_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/reasons_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/cancel_trip_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/completed_trip_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/rider_in_start_location_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/start_trip_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_reasons_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/record_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:url_launcher/url_launcher.dart';

class TripInfoByDriverScreen extends StatefulWidget {
  const TripInfoByDriverScreen({super.key, required this.model});
  final CheckAcceptByRiderModel model;

  @override
  State<TripInfoByDriverScreen> createState() => _TripInfoByDriverScreenState();
}

class _TripInfoByDriverScreenState extends State<TripInfoByDriverScreen> {
  bool inLocation = true;
  bool start = false;
  bool complete = false;
  int? otp;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveData();
  }

  saveData() {
    CacheService cacheService = CacheServiceImpl();
    cacheService.saveDriverTripInfo(model: widget.model);
  }

  removeData() {
    CacheService cacheService = CacheServiceImpl();
    cacheService.removeRiderTripInfo();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        key: scaffoldKey,
        body: BlocListener<CompletedTripRiderCubit, RiderState>(
          listener: (context, state) {
            if (state is FailureRiderState) {
              showErrorMessage(
                  context, getFailureMessage(state.failure, context));
            }
            if (state is SuccessCompletedTripRiderState) {
              setState(() {
                removeData();
                showSuccessMessage(context, LocaleKeys.tripIsComplete.tr());
                context.pushAndRemoveUntil(
                  Routes.HOME,
                  (route) => false,
                );
              });
            }
          },
          child: BlocListener<StartTripRiderCubit, RiderState>(
            listener: (context, state) {
              log(state.toString());
              if (state is FailureRiderState) {
                showErrorMessage(
                    context, getFailureMessage(state.failure, context));
              }
              if (state is SuccessStartTripRiderState) {
                setState(() {
                  start = false;
                  complete = true;
                  inLocation = false;
                  context.pop();
                });
              }
            },
            child: BlocListener<CancelTripRiderCubit, RiderState>(
              listener: (context, state) {
                log(state.toString(),
                    name: "CancelTripRiderCubitCancelTripRiderCubit");
                if (state is FailureRiderState) {
                  showErrorMessage(
                      context, getFailureMessage(state.failure, context));
                }
                if (state is SuccessCancelTripRiderState) {
                  context.read<RecordRideCubit>().stopRecord(
                              subcategoryId: widget.model?.subCategoryId??"",
                              tripId: widget.model?.id??""
                            );
                  removeData();
                  showSuccessDialog(context, LocaleKeys.successCancelTrip.tr());
                  context.pushAndRemoveUntil(
                    Routes.HOME,
                    (route) => false,
                  );
                }
              },
              child: BlocListener<RiderInStartLocationCubit, RiderState>(
                listener: (context, state) {
                  if (state is SuccessRiderInStartLocationState) {
                    setState(() {
                      inLocation = false;
                      start = true;
                    });
                  }
                },
                child: BlocListener<GetReasonsCubit, RiderState>(
                  listener: (context, state) {
                    if (state is SuccessGetResonsState) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content:
                                BlocListener<CancelTripRiderCubit, RiderState>(
                              listener: (context, state) {
                                log(state.toString(),
                                    name: "lkdjslkdfjslkdjflskdjf");
                                if (state is SuccessCancelTripRiderState) {
                                  removeData();
                                  showSuccessMessage(context,
                                      LocaleKeys.successCancelTrip.tr());
                                  context.pop();
                                  context.pushReplacement(
                                    Routes.RIDE,
                                  );
                                }
                                if (state is FailureRiderState) {
                                  showErrorMessage(
                                      context,
                                      getFailureMessage(
                                          state.failure, context));
                                }
                              },
                              child: ReasonsDilogWidget(
                                list: state.list,
                                onTap: (reasonsId) {
                                  log("slkdjflskdjlsdkjf",
                                      name: reasonsId.toString());
                                  context
                                      .read<CancelTripRiderCubit>()
                                      .cancelTripRider(
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
                  // listener: (context, state) {
                  //   if (state is SuccessGetResonsState) {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return AlertDialog(
                  //             content: BlocListener<CancelTripRiderCubit,
                  //                 RiderState>(
                  //           listener: (context, state) {
                  //             log(state.toString(),
                  //                 name:
                  //                     "CancelTripRiderCubitCancelTripRiderCubit");
                  //             if (state is FailureRiderState) {
                  //               showErrorMessage(context,
                  //                   getFailureMessage(state.failure, context));
                  //             }
                  //             if (state is ) {

                  //               showSuccessMessage(
                  //                   context, "Success Cancel Trip ii");
                  //               context.pushReplacement(
                  //                 Routes.RIDE,
                  //               );
                  //               removeData();
                  //             }
                  //           },
                  //           child: ReasonsDilogWidget(
                  //             onTap: (reasonsId) {
                  //               context
                  //                   .read<CancelTripRiderCubit>()
                  //                   .cancelTripRider(
                  //                       id: widget.model.id ?? "",
                  //                       reasonId: reasonsId,
                  //                       note: "");
                  //               context.pop();
                  //             },
                  //             list: state.list,
                  //           ),
                  //         ));
                  //       },
                  //     );
                  //   }
                  //   if (state is FailureRiderState) {
                  //     showErrorMessage(
                  //         context, getFailureMessage(state.failure, context));
                  //   }
                  // },
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
                                            color: const Color.fromRGBO(
                                                6, 147, 45, 1),
                                            width: 5)),
                                  ),
                                  const Sizer(
                                    width: 24,
                                  ),
                                  Flexible(
                                      child: Text(
                                    "${widget.model.fromTitle}",
                                    style: Styles.mediumText(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
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
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
                                  ))
                                ],
                              ),
                              const Sizer(
                                height: 30,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                width: double.infinity,
                                height: 46,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(226, 244, 255, 1),
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
                            ],
                          ),
                          // Spacer(),
                          const Sizer(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: AppButton(
                                  backColor: AppColors.PRIMARY_COLOR,
                                  height: 80.h,
                                  style: Styles.mediumText(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                  width: double.infinity,
                                  label: LocaleKeys.openGoogleMap.tr(),
                                  onPressed: () {
                                    log("sldkfjsldkjf");
                                    if (inLocation) {
                                      openGoogleMaps(
                                        lat: widget.model.startLocation!
                                            .coordinates![0],
                                        lng: widget.model.startLocation!
                                            .coordinates![1],
                                      );
                                    } else {
                                      openGoogleMaps(
                                        lat: widget.model.targetLocation!
                                            .coordinates![0],
                                        lng: widget.model.targetLocation!
                                            .coordinates![1],
                                      );
                                    }
                                  },
                                ),
                              ),
                              const Sizer(),
                              Flexible(
                                child: AppButton(
                                  backColor: AppColors.PRIMARY_COLOR,
                                  height: 80.h,
                                  style: Styles.mediumText(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                  width: double.infinity,
                                  label: inLocation
                                      ? LocaleKeys.inLocation.tr()
                                      : start
                                          ? LocaleKeys.start.tr()
                                          : LocaleKeys.complete.tr(),
                                  onPressed: () {
                                    if (inLocation) {
                                      context
                                          .read<RiderInStartLocationCubit>()
                                          .riderInStartLocation(
                                              id: widget.model.id ?? "");
                                    } else if (start) {
                                      scaffoldKey.currentState?.showBottomSheet(
                                        (context) {
                                          return Container(
                                            padding: const EdgeInsets.all(20),
                                            height: 200,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Pinput(
                                                  length: 6,
                                                  onChanged: (value) {
                                                    otp = int.tryParse(value);
                                                  },
                                                  validator: (value) {
                                                    if (value!.length < 6) {
                                                      return LocaleKeys
                                                          .InvalidOTP.tr();
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                DefaultButton(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () {
                                                    if (formKey.currentState
                                                            ?.validate() ==
                                                        true) {
                                                      context
                                                          .read<
                                                              StartTripRiderCubit>()
                                                          .startTripRider(
                                                              id: widget.model
                                                                      .id ??
                                                                  "",
                                                              otp: otp!);
                                                    }
                                                  },
                                                  label:
                                                      LocaleKeys.confirm.tr(),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    } else if (complete) {
                                      context
                                          .read<CompletedTripRiderCubit>()
                                          .completedTripRider(
                                              id: widget.model.id ?? "");
                                    }
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
                                  style: Styles.headerText(
                                    color: Colors.white,
                                  ),
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
// reasons

class ReasonsDilogWidget extends StatelessWidget {
  const ReasonsDilogWidget(
      {super.key, required this.list, required this.onTap});
  final List<ReasonsModel> list;
  final void Function(String reasonsId) onTap;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: list.map(
          (e) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    onTap(e.id!);
                  },
                  child: Text(e.reason.toString()),
                ),
                const Divider()
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}