import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/trip_states_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_trip_by_rider.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/dashboards_cubit/dashboards_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/ride_mode_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_driver_arrival_timer_card.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_driver_arrived_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_driver_complete_trip_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_driver_otp_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_driver_rate_client_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_go_to_client_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_safety_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/support_ride_screen.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/screen/custom_map.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;

class TrackingActiveTrip extends StatefulWidget {
  const TrackingActiveTrip({super.key, required this.params});
  final RideModeParams params;

  @override
  State<TrackingActiveTrip> createState() => _TrackingActiveTripState();
}

class _TrackingActiveTripState extends State<TrackingActiveTrip> {
  bool _locationServiceEnabled = true;
  StreamSubscription<ServiceStatus>? _locationServiceSub;

  @override
  void initState() {
    super.initState();
    _checkInitialLocationService();
    _startLocationServiceListener();
  }

  void _checkInitialLocationService() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      _locationServiceEnabled = enabled;
    });
  }

  void _startLocationServiceListener() {
    _locationServiceSub = Geolocator.getServiceStatusStream().listen((status) {
      final enabled = status == ServiceStatus.enabled;
      if (_locationServiceEnabled != enabled) {
        setState(() {
          _locationServiceEnabled = enabled;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_locationServiceEnabled) {
      return Expanded(
        child: Center(
          child: Text(
            context.isArabic
                ? 'يرجى تشغيل خدمة الموقع للتمكن من رؤية رحلتك الجارية'
                : 'Please enable location service to track your active trip',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
      );
    }
    return BlocBuilder<DashboardsCubit, DashboardsState>(
        builder: (context, state) {
      var cubit = context.read<DashboardsCubit>();
      return Expanded(
          child: Stack(
        children: [
          if (state.tripStatus == TripState.accepted.name ||
              state.tripStatus == TripState.goToClient.name ||
              state.tripStatus == TripState.completed.name ||
              state.tripStatus == TripState.inLocation.name ||
              state.tripStatus == TripState.started.name ||
              state.tripStatus == TripState.support.name)
            _buildTopMap(context, state),
          if (state.tripStatus == TripState.goToClient.name &&
              cubit.activeTrip?.driverIsArrivingIn != null &&
              (cubit.activeTrip?.driverIsArrivingIn?.isNotEmpty ?? false) &&
              (DateTime.parse(cubit.activeTrip?.driverIsArrivingIn ?? '')
                  .toLocal()
                  .isAfter(DateTime.now())))
            PositionedDirectional(
                top: 20.h,
                start: 100.w,
                end: 100.w,
                child: CountdownTimerCard(
                  targetTime:
                      DateTime.parse(cubit.activeTrip?.driverIsArrivingIn ?? '')
                          .toLocal(),
                )),
          if ((cubit.activeTrip == null ||
              state.tripStatus == TripState.canceled.name ||
              state.tripStatus == ''))
            Center(
                child: Text(
                    context.isArabic
                        ? 'لا يوجد لديك رحلة جارية في الوقت الحالي'
                        : "You don't have active trip at the moment",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 16))),
          // DynamicMapWithPolyline(url: getMapUrl(context, type: "mapBox"), apiKey: getApiKey(context, type: "mapBox")),
          if (state.tripStatus == TripState.goToClient.name)
            BuildDriverArrivedSheet(
                onPressed: (String message) {
                  ManageVibration.vibrate();
                  cubit.arrivedToClient(
                      context, cubit.activeTrip?.tripId ?? '', message);
                },
                onSafety: () {
                  ManageVibration.vibrate();
                  cubit.showSafety(state.tripStatus ?? '');
                },
                onCancelTrip: (CancelTripByRiderUseCaseParams params) {
                  ManageVibration.vibrate();
                  cubit.cancelDriverTrip(
                      context: context,
                      tripId: params.tripId,
                      note: params.note,
                      reasonId: params.reasonId,
                      params: widget.params);
                },
                onReport: () {
                  ManageVibration.vibrate();
                  bottomSheet(
                      context: context,
                      widget: ReportView(
                        id: cubit.activeTrip?.tripId ?? '',
                        categoryId: cubit.activeTrip?.subCategoryId ?? '',
                      ));
                },
                params: widget.params,
                activeTrip: cubit.activeTrip),
          if (state.tripStatus == TripState.accepted.name)
            BuildGoToClientSheet(
              onGoingToClient: () {
                ManageVibration.vibrate();
                cubit.goingToClient(context, cubit.activeTrip?.tripId ?? '');
              },
              activeTrip: cubit.activeTrip,
              onSafety: () {
                ManageVibration.vibrate();
                cubit.showSafety(state.tripStatus ?? '');
              },
              onReport: () {
                ManageVibration.vibrate();
                bottomSheet(
                    context: context,
                    widget: ReportView(
                      id: cubit.activeTrip?.tripId ?? '',
                      categoryId: cubit.activeTrip?.subCategoryId ?? '',
                    ));
              },
              onCancelTrip: (CancelTripByRiderUseCaseParams params) {
                ManageVibration.vibrate();
                cubit.cancelDriverTrip(
                    context: context,
                    tripId: params.tripId,
                    note: params.note,
                    reasonId: params.reasonId,
                    params: widget.params);
              },
              params: widget.params,
            ),
          if (state.tripStatus == TripState.inLocation.name)
            BuildDriverOtpSheet(
              onPressed: (String otp) {
                ManageVibration.vibrate();
                cubit.startDriverTrip(
                    context, cubit.activeTrip?.tripId ?? '', otp);
              },
              onCancelTrip: (CancelTripByRiderUseCaseParams params) {
                ManageVibration.vibrate();
                cubit.cancelDriverTrip(
                    context: context,
                    tripId: params.tripId,
                    note: params.note,
                    reasonId: params.reasonId,
                    params: widget.params);
              },
              onSafety: () {
                ManageVibration.vibrate();
                cubit.showSafety(state.tripStatus ?? '');
              },
              onTick: (Duration time) {
                DateTime future = DateTime.now().add(time);
                cubit.updateRemainingTime(future);
              },
              onFinalizeTrip: () {
                ManageVibration.vibrate();
                cubit.finalizeTripByRider(
                    context: context,
                    tripId: cubit.activeTrip?.tripId ?? '',
                    params: widget.params);
              },
              onReport: () {
                ManageVibration.vibrate();
                print("object");
                bottomSheet(
                    context: context,
                    widget: ReportView(
                      id: cubit.activeTrip?.tripId ?? '',
                      categoryId: cubit.activeTrip?.subCategoryId ?? '',
                    ));
              },
              remainingTime: state.remainingTime,
              activeTrip: cubit.activeTrip,
              params: widget.params,
            ),
          if (state.tripStatus == TripState.started.name)
            BuildDriverCompleteTripSheet(
              activeTrip: cubit.activeTrip,
              onPressed: (String) {
                ManageVibration.vibrate();
              },
              onStartRecord: () {
                ManageVibration.vibrate();
                cubit.startRecord();
              },
              onStopRecord: () {
                ManageVibration.vibrate();
                cubit.stopRecord(
                    context: context,
                    subcategoryId: cubit.activeTrip?.subCategoryId ?? '',
                    tripId: cubit.activeTrip?.tripId ?? '');
              },
              onCompleteRide: () {
                ManageVibration.vibrate();
                cubit.completeDriverTrip(
                    context, cubit.activeTrip?.tripId ?? '', '');
              },
              onCompleteRideWithPrice: (String price) {
                ManageVibration.vibrate();
                cubit.completeDriverTripWithPrice(
                    context, cubit.activeTrip?.tripId ?? '', price);
              },
              onCancelTrip: (CancelTripByRiderUseCaseParams params) {
                ManageVibration.vibrate();
                cubit.cancelDriverTrip(
                    context: context,
                    tripId: params.tripId,
                    note: params.note,
                    reasonId: params.reasonId,
                    params: widget.params);
              },
              onSafety: () {
                ManageVibration.vibrate();
                cubit.showSafety(state.tripStatus ?? '');
              },
              onReport: () {
                ManageVibration.vibrate();
                bottomSheet(
                    context: context,
                    widget: ReportView(
                      id: cubit.activeTrip?.tripId ?? '',
                      categoryId: cubit.activeTrip?.subCategoryId ?? '',
                    ));
              },
              tripId: cubit.activeTrip?.tripId ?? '',
              params: widget.params,
            ),
          if (state.tripStatus == TripState.completed.name)
            BuildDriverRateClientSheet(
              onPressed: (message, rate) {
                ManageVibration.vibrate();
                print("message $message ||| rate $rate");
                cubit.rateTheClient(
                    context: context,
                    tripId: cubit.activeTrip?.tripId ?? '',
                    comment: message,
                    rate: rate,
                    params: widget.params);
              },
            ),
          if (state.tripStatus == TripState.support.name)
            BuildSafetySheet(
              params: SupportRideParams(
                  tripId: cubit.activeTrip?.tripId ?? '',
                  tripType: 'tracing',
                  userType: 'driver',
                  driverId: cubit.activeTrip?.driverId ?? '',
                  clientId: cubit.activeTrip?.clientId ?? ''),
              onClose: () {
                ManageVibration.vibrate();
                cubit.closeSafety();
              },
              supportRideScreen: () {
                ManageVibration.vibrate();
                context.push(
                  Routes.supportRideScreen,
                  extra: SupportRideParams(
                    tripId: cubit.activeTrip?.tripId ?? '',
                    tripType: 'tracing',
                    userType: 'driver',
                    driverId: cubit.activeTrip?.driverId ?? '',
                    clientId: cubit.activeTrip?.clientId ?? '',
                  ),
                );
              },
              emergencyContactsScreen: () {
                ManageVibration.vibrate();
                context.push(Routes.emergencyContactsScreen);
              },
              rideFindingScreen: () {
                ManageVibration.vibrate();
                context.push(Routes.rideFindingScreen);
              },
            ),
        ],
      ));
    });
  }

  Widget _buildTopMap(BuildContext context, DashboardsState state) {
    String tripStatus = context.read<DashboardsCubit>().state.tripStatus ?? '';
    List<gmap.LatLng> routePoints = [];
    List<gmap.LatLng> driverRoutePoints = [];
    routePoints = _convertPolylineToLatLng(
        context.read<DashboardsCubit>().activeTrip?.polyline ?? []);
    driverRoutePoints = _convertPolylineToLatLng(
        context.read<DashboardsCubit>().activeTrip?.driverPolyline ?? []);

    List<gmap.LatLng> clients = [];
    List<String> clientsAddress = [];
    if (context.read<DashboardsCubit>().activeTrip?.wayPointOne != null &&
        context.read<DashboardsCubit>().activeTrip?.wayPointOne?[0] != null &&
        context.read<DashboardsCubit>().activeTrip?.wayPointOne?[1] != null &&
        context.read<DashboardsCubit>().activeTrip?.wayPointOne?[0] != 0 &&
        context.read<DashboardsCubit>().activeTrip?.wayPointOne?[1] != 0) {
      clients.add(gmap.LatLng(
          context.read<DashboardsCubit>().activeTrip!.wayPointOne![0],
          context.read<DashboardsCubit>().activeTrip!.wayPointOne![1]));
    }

    if (context.read<DashboardsCubit>().activeTrip?.wayPointTwo != null &&
        context.read<DashboardsCubit>().activeTrip?.wayPointTwo?[0] != null &&
        context.read<DashboardsCubit>().activeTrip?.wayPointTwo?[1] != null &&
        context.read<DashboardsCubit>().activeTrip?.wayPointTwo?[0] != 0 &&
        context.read<DashboardsCubit>().activeTrip?.wayPointTwo?[1] != 0) {
      clients.add(gmap.LatLng(
          context.read<DashboardsCubit>().activeTrip!.wayPointTwo![0],
          context.read<DashboardsCubit>().activeTrip!.wayPointTwo![1]));
    }

    if (context
            .read<DashboardsCubit>()
            .activeTrip
            ?.wayPointOneTitle
            ?.isNotEmpty ??
        false) {
      clientsAddress.add(
          context.read<DashboardsCubit>().activeTrip?.wayPointOneTitle ?? '');
    }
    if (context
            .read<DashboardsCubit>()
            .activeTrip
            ?.wayPointTwoTitle
            ?.isNotEmpty ??
        false) {
      clientsAddress.add(
          context.read<DashboardsCubit>().activeTrip?.wayPointTwoTitle ?? '');
    }

    print(
        "context.read<DashboardsCubit>().activeTrip?.driverPolyline ${context.read<DashboardsCubit>().activeTrip?.driverPolyline}");
    print("tripStatus11 $tripStatus");
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.grey,
      ),
      child: ClipRect(
        child: CustomGoogleMap(
          // key: ValueKey('map_${DateTime.now().millisecondsSinceEpoch}'), // Force rebuild
          startLocation: tripStatus == TripState.inLocation.name
              ? null
              : (tripStatus == TripState.goToClient.name ||
                      tripStatus == TripState.accepted.name)
                  ? ((context
                                  .read<DashboardsCubit>()
                                  .activeTrip
                                  ?.driverStartCoordinates ==
                              null) ||
                          (context
                                  .read<DashboardsCubit>()
                                  .activeTrip
                                  ?.driverStartCoordinates ==
                              []))
                      ? null
                      : gmap.LatLng(
                          context
                              .read<DashboardsCubit>()
                              .activeTrip!
                              .driverStartCoordinates![0],
                          context
                              .read<DashboardsCubit>()
                              .activeTrip!
                              .driverStartCoordinates![1])
                  : ((context
                                  .read<DashboardsCubit>()
                                  .activeTrip
                                  ?.startCoordinates ==
                              null) ||
                          (context
                                  .read<DashboardsCubit>()
                                  .activeTrip
                                  ?.startCoordinates ==
                              []))
                      ? null
                      : gmap.LatLng(
                          context
                              .read<DashboardsCubit>()
                              .activeTrip!
                              .startCoordinates![1],
                          context
                              .read<DashboardsCubit>()
                              .activeTrip!
                              .startCoordinates![0]),
          targetLocation: tripStatus == TripState.inLocation.name
              ? null
              : (tripStatus == TripState.goToClient.name ||
                      tripStatus == TripState.accepted.name)
                  ? ((context
                                  .read<DashboardsCubit>()
                                  .activeTrip
                                  ?.driverTargetCoordinates ==
                              null) ||
                          (context
                                  .read<DashboardsCubit>()
                                  .activeTrip
                                  ?.driverTargetCoordinates ==
                              []))
                      ? null
                      : gmap.LatLng(
                          context
                              .read<DashboardsCubit>()
                              .activeTrip!
                              .driverTargetCoordinates![0],
                          context
                              .read<DashboardsCubit>()
                              .activeTrip!
                              .driverTargetCoordinates![1])
                  : ((context
                                  .read<DashboardsCubit>()
                                  .activeTrip
                                  ?.targetCoordinates ==
                              null) ||
                          (context
                                  .read<DashboardsCubit>()
                                  .activeTrip
                                  ?.targetCoordinates ==
                              []))
                      ? null
                      : gmap.LatLng(
                          context
                              .read<DashboardsCubit>()
                              .activeTrip!
                              .targetCoordinates![1],
                          context
                              .read<DashboardsCubit>()
                              .activeTrip!
                              .targetCoordinates![0]),
          polylinePoints: tripStatus == TripState.inLocation.name
              ? []
              : (tripStatus == TripState.goToClient.name ||
                      tripStatus == TripState.accepted.name)
                  ? driverRoutePoints
                  : routePoints,
          clientLocations: tripStatus == TripState.inLocation.name
              ? []
              : (tripStatus == TripState.goToClient.name ||
                      tripStatus == TripState.accepted.name)
                  ? []
                  : clients,
          enableScrolling: true,
          fromClient: (context.read<DashboardsCubit>().activeTrip != null &&
                      (state.tripStatus == TripState.started.name ||
                          state.tripStatus == TripState.goToClient.name ||
                          state.tripStatus == TripState.inLocation.name)) ==
                  true
              ? false
              : null,
          startAddress: context.read<DashboardsCubit>().activeTrip?.from,
          targetAddress: context.read<DashboardsCubit>().activeTrip?.to,
          clientAddresses: (tripStatus == TripState.goToClient.name ||
                  tripStatus == TripState.accepted.name)
              ? []
              : clientsAddress,
          estimatedTime: (tripStatus == TripState.goToClient.name ||
                  tripStatus == TripState.inLocation.name)
              ? DateFormat('h:mm a').format(DateTime.parse(context
                          .read<DashboardsCubit>()
                          .activeTrip
                          ?.driverIsArrivingIn ??
                      '')
                  .toLocal())
              : tripStatus == TripState.started.name
                  ? DateFormat('h:mm a').format(DateTime.parse(context
                              .read<DashboardsCubit>()
                              .activeTrip
                              ?.tripStartTime ??
                          '')
                      .toLocal()
                      .add(
                          Duration(minutes: context.read<DashboardsCubit>().activeTrip?.duration ?? 0)))
                  : '',
          status: tripStatus,
        ),
      ),
    );
  }

  List<gmap.LatLng> _convertPolylineToLatLng(List<List<double>> polyline) {
    return polyline.map((point) => gmap.LatLng(point[1], point[0])).toList();
  }
}
