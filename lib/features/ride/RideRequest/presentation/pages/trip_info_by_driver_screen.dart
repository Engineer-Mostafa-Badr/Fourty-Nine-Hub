import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_by_rider_model/check_accept_by_rider_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/reasons_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/cancel_trip_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/completed_trip_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/rider_in_start_location_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/start_trip_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_reasons_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
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
    getState();
  }

  getState() async {
    String state = await CacheServiceImpl().getTripState();
    log(state, name: "018233333333333333");
    if (state == "InLocation") {
      inLocation = true;
    } else if (state == "start") {
      inLocation = false;
      start = true;
    } else if (state == "complete") {
      complete = true;
      inLocation = false;
      start = false;
    }
    setState(() {});
  }

  saveData() {
    CacheService cacheService = CacheServiceImpl();
    cacheService.saveDriverTripInfo(model: widget.model);
  }

  removeData() {
    CacheService cacheService = CacheServiceImpl();
    cacheService.removeDriverTripInfo();
    cacheService.removeTripState();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Timer? _timer;
  int _countdown = 10;
  void startCountdown(int seconds) {
    setState(() {
      _countdown = seconds;
    });

    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_countdown > 0) {
          setState(() {
            _countdown--;
          });
        } else {
          timer.cancel(); // إنهاء العداد عندما يصل إلى الصفر
        }
      },
    );
  }

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
                CacheServiceImpl().saveTripState("complete");
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
                      CacheServiceImpl().saveTripState("start");
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
                                      border: Border.all(
                                          color: Colors.blue, width: 3)),
                                ),
                                const Sizer(),
                                Flexible(
                                    child: Text(widget.model.fromTitle ?? ""))
                              ],
                            ),
                            const Sizer(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.green, width: 3)),
                                ),
                                const Sizer(),
                                Flexible(
                                    child: Text(widget.model.toTitle ?? "")),
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
                                    "${LocaleKeys.destination.tr()} : ${formatDistance(widget.model.distance ?? 0)}"),
                              ],
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
                              child: DefaultButton(
                                padding: EdgeInsets.zero,
                                width: double.infinity,
                                label: LocaleKeys.openGoogleMap.tr(),
                                onPressed: () {
                                  log("sldkfjsldkjf");
                                  if (inLocation) {
                                    openGoogleMaps(
                                      lat: widget
                                          .model.startLocation!.coordinates![0],
                                      lng: widget
                                          .model.startLocation!.coordinates![1],
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
                              child: DefaultButton(
                                padding: EdgeInsets.zero,
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Pinput(
                                                length: 6,
                                                onChanged: (value) {
                                                  otp = int.tryParse(value);
                                                },
                                                validator: (value) {
                                                  if (value!.length < 6) {
                                                    return LocaleKeys.InvalidOTP
                                                        .tr();
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
                                                            id: widget
                                                                    .model.id ??
                                                                "",
                                                            otp: otp!);
                                                  }
                                                },
                                                label: LocaleKeys.confirm.tr(),
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
                              child: DefaultButton(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.zero,
                                width: double.infinity,
                                label: LocaleKeys.cancel.tr(),
                                onPressed: () {
                                  // removeData();
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
