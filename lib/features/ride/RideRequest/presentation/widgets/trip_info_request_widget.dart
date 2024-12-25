import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_trip_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/location_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/offer_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/raise_fare_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/request_rider_trip_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_trip_reel_time_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/show_offers_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/ride_request_view.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/trip_info_button_sheet_widget.dart';
import 'package:fourtyninehub/features/ride/rider_shipping/presentation/pages/create_trip_rider.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class TripInfoRequestWidget extends StatefulWidget {
  const TripInfoRequestWidget({super.key, required this.model});
  final GetTripInfoModel model;

  @override
  State<TripInfoRequestWidget> createState() => _TripInfoRequestWidgetState();
}

class _TripInfoRequestWidgetState extends State<TripInfoRequestWidget> {
  bool isBottomSheetShown = false;
  String formatDuration(int totalSeconds) {
    if (totalSeconds >= 3600) {
      int hours = totalSeconds ~/ 3600;
      int minutes = (totalSeconds % 3600) ~/ 60;
      return '$hours h, $minutes min';
    } else if (totalSeconds >= 60) {
      int minutes = totalSeconds ~/ 60;
      int seconds = totalSeconds % 60;
      return '$minutes min, $seconds s';
    } else {
      return '$totalSeconds s';
    }
  }

  String formatDistance(int meters) {
    if (meters >= 1000) {
      double kilometers = meters / 1000;
      return '${kilometers.toStringAsFixed(2)} km';
    } else {
      return '$meters m';
    }
  }

  @override
  void initState() {
    BlocProvider.of<GetCurrencyCubit>(context).getCurrencyData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OfferCubit, RiderState>(
      listener: (context, state) {
        if (state is SuccessAcceptOfferRideState) {
          context.pushAndRemoveUntil(
            Routes.TRIPINFOBYRIDERSCREEN,
            extra: state.model,
            (route) => false,
          );
        }
      },
      child: BlocBuilder<OfferCubit, RiderState>(builder: (context, state) {
        log(state.toString(), name: "SuccessAcceptOfferRideState");
        return BlocListener<RequestRiderTripCubit, RiderState>(
          listener: (context, state) async {
            log(state.toString(), name: "klsjdlkjfslkdjflskdjf");
            if (state is SuccessRequestTripState) {
              // await BlocProvider.of<GetCurrencyCubit>(context)
              //     .getCurrencyData();

              context.pop();
              // await BlocProvider.of<GetCurrencyCubit>(context)
              //     .getCurrencyData();

              context.read<ShowOffersCubit>().showOffers();
              context.read<LocationSocketCubit>().nearbyDriversEmit(
                  tripId: state.model.trip?.id ?? "",
                  location: state.model.trip?.startLocation?.coordinates ?? [],
                  subcategoryId: state.model.trip?.subCategoryId ?? "");

              showModalBottomSheet(
                context: context,
                isDismissible: false, // Prevent dismissing by tapping outside
                enableDrag: false, // Prevent drag to dismiss
                isScrollControlled: true, // Allow full-screen height if needed
                builder: (context) {
                  return GestureDetector(
                    onVerticalDragStart: (_) {}, // Disable manual drag gestures
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
          child: BlocListener<ShowOffersCubit, RiderState>(
            listener: (context, state) async {
              if (state is SuccessGetOfferDataState) {
                log(state.toString(), name: "SuccessGetOfferDataState");
                if (state.data != null) {
                  await BlocProvider.of<GetCurrencyCubit>(context)
                      .getCurrencyData();
                  log(state.data?.firstName.toString() ?? "null",
                      name: "slkfjslkdjf");
                  final overlay = Overlay.of(context);
                  final overlayEntry = OverlayEntry(
                    builder: (context) => Positioned(
                      top: 30,
                      left: 10,
                      right: 10,
                      child: Material(
                          child: BlocProvider(
                        create: (context) => GetCurrencyCubit(serviceLocator()),
                        child: AcceptOrDeclineTrip(
                          tripId: state.data?.id ?? "",
                          model: state.data!,
                        ),
                      )),
                    ),
                  );
                  context.read<ShowOffersCubit>().overlayEntry = overlayEntry;
                  overlay.insert(overlayEntry);
                  // Remove the overlay after some time or on user action
                  Future.delayed(const Duration(seconds: 15), () {
                    overlayEntry.remove();
                  });
                }
              }
            },
            child: BlocBuilder<RiderTripReelTimeCubit, RiderState>(
              builder: (context, state) {
                if (state is ViewPickTripDataState) {
                  log(state.toString(), name: "lskdjflskdjflkjfdlkddddd");
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Column(
                      children: [
                        // BlocListener<GetTripInfoCubit, RiderState>(
                        //   listener: (context, state) {
                        //     if (state is SuccessGetTripInfoState) {
                        //       if (!isBottomSheetShown) {
                        //         isBottomSheetShown = true;
                        //         WidgetsBinding.instance.addPostFrameCallback(
                        //           (timeStamp) {
                        //             context
                        //                 .read<RiderTripReelTimeCubit>()
                        //                 .print();
                        //             BlocProvider.of<GetCurrencyCubit>(context)
                        //                 .getCurrencyData();

                        //             showModalBottomSheet(
                        //               isScrollControlled: true,
                        //               backgroundColor: Colors.white,
                        //               context: context,
                        //               builder: (context) => MultiBlocProvider(
                        //                 providers: [
                        //                   BlocProvider(
                        //                       create: (context) =>
                        //                           GetTripInfoCubit(
                        //                               repository:
                        //                                   serviceLocator())),
                        //                 ],
                        //                 child: BlocProvider(
                        //                   create: (context) => GetCurrencyCubit(
                        //                       serviceLocator()),
                        //                   child: TripInfoButtonSheetWidget(
                        //                     model: state.model,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ).whenComplete(
                        //               () {
                        //                 isBottomSheetShown = false;
                        //               },
                        //             );
                        //           },
                        //         );
                        //       }
                        //     }
                        //   },
                        //   child: Container(),
                        // ),

                        const Sizer(),
                      ],
                    ),
                  );
                }
                return CreateTripRider();
              },
            ),
          ),
        );
      }),
    );
  }
}
