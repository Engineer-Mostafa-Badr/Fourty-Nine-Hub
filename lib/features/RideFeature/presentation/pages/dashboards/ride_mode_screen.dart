import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/trip_states_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_trip_by_rider.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_support_details_usecase.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/ride_dashboard_details_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/ride_dashboard_non_socket_details_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/available_ride_trip_item.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_driver_arrival_timer_card.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_driver_arrived_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_driver_otp_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_driver_complete_trip_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_driver_rate_client_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_go_to_client_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_safety_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_home.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/settings_not_socket_loading.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/support_ride_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/settings_not_socket.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/available_non_socket_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/screen/custom_map.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:fourtyninehub/shared_web_socket.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import '../../../../carpool/add_new_route/presentation/widgets/dynamic_map_test.dart';
import '../../controllers/dashboards_cubit/dashboards_cubit.dart';
import '../loading_dashboard/accepted_non_socket_loading.dart';
import '../loading_dashboard/available_loading_widget.dart';
import '../loading_dashboard/past_loading_widget.dart';
import '../ride_details_screen.dart';
import '../widgets/accepted_non_socket_widget.dart';
import '../widgets/map_section.dart';
import '../widgets/past_trip_non_socket_widget.dart';
import 'widgets/not_ready_available_trips_widget.dart';
import 'widgets/past_trips_widget.dart';
import 'widgets/settings_widget.dart';
import 'widgets/truk_bus_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;

class RideModeParams {
  final String modeType;
  final bool? isSocket;
  final int? currentIndex;

  const RideModeParams({required this.modeType, this.isSocket, this.currentIndex});
}

class RideModeScreen extends StatefulWidget {
  final RideModeParams params;

  const RideModeScreen({super.key, required this.params});

  @override
  State<RideModeScreen> createState() => _RideModeScreenState();
}

class _RideModeScreenState extends State<RideModeScreen> {
  final ScrollController _scrollController = ScrollController();
  late ScrollController _availableTripsScrollController;
  late ScrollController _pastTripsScrollController;

  @override
  dispose() {
    SharedWebSocket.socket!.off("REID:NEW_AVAILABLE_TRIP");
    var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    currentContext.read<MainCategoriesCubit>().listenToNewTrip(currentContext, currentContext.read<MainCategoriesCubit>().state.setting?.data.enableNotificationSound ?? false);
    print("dispose REID:NEW_AVAILABLE_TRIP");
    super.dispose();
  }

  @override
  void initState() {
    SharedWebSocket.socket!.off("REID:NEW_AVAILABLE_TRIP");
    print("widget.params.isSocket ${widget.params.isSocket}");
    super.initState();
    _availableTripsScrollController = ScrollController()..addListener(_onScroll);
    _pastTripsScrollController = ScrollController()..addListener(_onScrollPastTrips);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardCubit = context.read<DashboardsCubit>();
      // if (!dashboardCubit.isClosed) {
      widget.params.isSocket == true
          ? [
              dashboardCubit.changeIndex(widget.params.currentIndex ?? 0, context, widget.params),
              // if (widget.params.currentIndex == null || widget.params.currentIndex == 0) dashboardCubit.loadAvailableRideTrips(context),
              dashboardCubit.listenToUpdateTripAutoAccept(),
              dashboardCubit.listenToUpdateTripPrice(),
              dashboardCubit.listenToAcceptOffer(context, widget.params),
              dashboardCubit.listenToNewTrip(widget.params),
              dashboardCubit.listenToRemoveTrip(),
              dashboardCubit.listenToClientComing(),
              dashboardCubit.listenToEndTrip(context, widget.params),
              dashboardCubit.listenToPartialPaymentDriver(context),
            ]
          : [
              widget.params.modeType == "ride" ? dashboardCubit.loadInitialAvailableNonSocketTrips() : dashboardCubit.loadInitialAvailableNonSocketLoading(),
              dashboardCubit.listenToRemoveUntrackedTrip(),
              dashboardCubit.listenToNewTripNonSocket(),
              dashboardCubit.listenToAcceptTripOfferTrip(4, context, widget.params),
              dashboardCubit.getDriverSettings(context),
              if (widget.params.modeType == "truck")
                {
                  dashboardCubit.listenToRemoveLoading(),
                  dashboardCubit.listenToNewLoading(),
                  // dashboardCubit.listenToAcceptLoadingOffer(),
                }
            ];
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      widget.params.isSocket == true && widget.params.currentIndex == 0
          ? context.read<DashboardsCubit>().getAvailableRideTrips(context)
          : [
              context.read<DashboardsCubit>().getAvailableNonSocketTrips(),
              context.read<DashboardsCubit>().getAvailableNonSocketLoading(),
            ];
    }
  }

  void _onScrollPastTrips() {
    if (widget.params.isSocket == true && context.read<DashboardsCubit>().state.currentIndex == 2) {
      print("object");
      if (_pastTripsScrollController.position.pixels >= _pastTripsScrollController.position.maxScrollExtent) {
        context.read<DashboardsCubit>().getPastTrips(context, widget.params.isSocket == true ? "tracking" : 'non-tracking');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SharedScaffold(
          mainCategoryId: 2,
          isWithBackArrow: true,
          body: NestedAppbar(
            scrollController: _scrollController,
            appBars: const [],
            body: BlocConsumer<DashboardsCubit, DashboardsState>(
              listener: (context, state) {
                // if (state.isErrorOffers) {
                //   String errorName = getFailureName(state.failure!, context);
                //   errorName == 'DebtError'
                //       ? showDebtDialog(
                //           context, state.availableTrips![0].subCategory!.id)
                //       : errorName == 'SubscribeError'
                //           ? showSubscribeDialog(
                //               context, state.availableTrips![0].subCategory!.id)
                //           : showErrorMessage(context,
                //               getFailureMessage(state.failure!, context));
                // }
              },
              builder: (context, state) {
                var cubit = context.read<DashboardsCubit>();
                print("state.tripStatus ${state.tripStatus}");
                print("cubit.activeTrip?.driverIsArrivingIn ${cubit.activeTrip?.driverIsArrivingIn}");

                return DefaultTabController(
                  length: 4,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GestureDetector(
                          // onTap: () {
                          //   context.pop();
                          // },
                          child: Row(
                            spacing: 8,
                            children: [
                              // const Icon(Icons.arrow_back),
                              Text(
                                  widget.params.modeType == "ride"
                                      ? LocaleKeys.rideMode.tr()
                                      // : widget.params.modeType == 'truk'?
                                      : LocaleKeys.trukMode.tr(),
                                  // : LocaleKeys.busMode.tr(),
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTabItem(
                              cubit.state.currentIndex ?? 0,
                              0,
                              LocaleKeys.available.tr(),
                              () {
                                ManageVibration.vibrate();
                                cubit.changeIndex(0, context, widget.params);
                                // setState(() {
                                //   _selectedIndex = 0;
                                // });
                              },
                            ),
                            if (widget.params.isSocket == true)
                              _buildTabItem(
                                cubit.state.currentIndex ?? 0,
                                1,
                                LocaleKeys.running.tr(),
                                () {
                                  ManageVibration.vibrate();
                                  cubit.changeIndex(1, context, widget.params);
                                  // setState(() {
                                  //   _selectedIndex = 1;
                                  // });
                                },
                              ),
                            if (widget.params.isSocket == false
                                // &&
                                // widget.params.modeType == "ride"
                                )
                              _buildTabItem(
                                cubit.state.currentIndex ?? 0,
                                4,
                                LocaleKeys.current.localize,
                                () {
                                  ManageVibration.vibrate();
                                  cubit.changeIndex(4, context, widget.params);
                                  // setState(() {
                                  //   _selectedIndex = 1;
                                  // });
                                },
                              ),
                            _buildTabItem(
                              cubit.state.currentIndex ?? 0,
                              2,
                              LocaleKeys.past.tr(),
                              () {
                                ManageVibration.vibrate();
                                cubit.changeIndex(2, context, widget.params);
                                // setState(() {
                                //   _selectedIndex = 2;
                                // });
                              },
                            ),
                            _buildFilterIcon(() {
                              ManageVibration.vibrate();
                              cubit.changeIndex(3, context, widget.params);
                              // setState(() {
                              //   _selectedIndex = 3;
                              // });
                            }, cubit.state.currentIndex ?? 0),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Available Trips
                      if (cubit.state.currentIndex == 0)
                        Expanded(
                          child: (state.settings?.isReady ?? true)
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: state.isLoadingAvailable
                                      ? const Center(child: CustomCircularProgressIndicator())
                                      : widget.params.modeType == "truck"
                                          ? cubit.isLoadingAvailableNonSocketLoading
                                              ? const Center(child: CustomCircularProgressIndicator())
                                              : cubit.availableLoadingNonSocketData.isEmpty
                                                  ? Center(
                                                      child: Text(
                                                        LocaleKeys.youDontHaveAvailableOffer.localize,
                                                      ),
                                                    )
                                                  : ListView.separated(
                                                      controller: _availableTripsScrollController,
                                                      itemBuilder: (context, index) => AvailableNonSocketLoadingWidget(offers: cubit.availableLoadingNonSocketData[index]),
                                                      itemCount: cubit.availableLoadingNonSocketData.length,
                                                      separatorBuilder: (context, index) => const SizedBox(height: 15),
                                                    )
                                          : widget.params.isSocket == true
                                              ? cubit.isLoadingAvailableRideTrips
                                                  ? const Center(child: CustomCircularProgressIndicator())
                                                  : cubit.availableRideTrips.isNotEmpty
                                                      ? Column(
                                                          children: [
                                                            Expanded(
                                                              child: ListView.separated(
                                                                  controller: _availableTripsScrollController,
                                                                  itemBuilder: (context, index) => AvailableRideTripItem(
                                                                        tripEntity: cubit.availableRideTrips[index],
                                                                        onRefuseTrip: (String id) {
                                                                          ManageVibration.vibrate();
                                                                          cubit.refuseTripOffer(id);
                                                                        },
                                                                        params: widget.params,
                                                                      ),
                                                                  itemCount: cubit.availableRideTrips.length,
                                                                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 15)),
                                                            ),
                                                          ],
                                                        )
                                                      : Center(
                                                          child: Text(
                                                            context.isArabic ? 'لا يوجد رحلات متاحة' : 'No Available Trips',
                                                            style: TextStyle(fontSize: FontSize.s18),
                                                          ),
                                                        )
                                              : (state.driverSettingsEntity?.isReady == false)
                                                  ? (cubit.isLoadingAvailableNonSocketTrips
                                                      ? const Center(child: CustomCircularProgressIndicator())
                                                      : Center(
                                                          child: Text(
                                                            LocaleKeys.youCantGetTripUntilYouReady.localize,
                                                            style: TextStyle(color: Colors.red, fontSize: 16),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ))
                                                  : (cubit.isLoadingAvailableNonSocketTrips
                                                      ? const Center(child: CustomCircularProgressIndicator())
                                                      : (cubit.availableRideNonSocketData.isEmpty
                                                          ? Center(child: Text(LocaleKeys.youDontHaveAvailableOffer.localize))
                                                          : ListView.separated(
                                                              controller: _availableTripsScrollController,
                                                              itemBuilder: (context, index) => AvailableNonSocketWidget(
                                                                offers: cubit.availableRideNonSocketData[index],
                                                              ),
                                                              itemCount: cubit.availableRideNonSocketData.length,
                                                              separatorBuilder: (context, index) => const SizedBox(height: 15),
                                                            ))))
                              : const NotReadyAvailableTripsWidget(),
                          // (state.driverSettingsEntity?.isReady !=
                          //                 true)
                          //             ? Center(
                          //                 child: Text(
                          //                   LocaleKeys
                          //                       .youCantGetTripUntilYouReady.localize,
                          //                   style: TextStyle(
                          //                       color: Colors.red,
                          //                       fontSize: 16),
                          //                   textAlign: TextAlign.center,
                          //                 ),
                          //               )
                          //             : cubit.isLoadingAvailableNonSocketTrips
                          //                     ? const Center(child: CustomCircularProgressIndicator())
                          //                     : cubit.availableRideNonSocketData.isEmpty
                          //                         ? Center(child: Text(LocaleKeys.youDontHaveAvailableOffer.localize))
                          //                         : ListView.separated(
                          //                             controller:
                          //                                 _availableTripsScrollController,
                          //                             itemBuilder: (context,
                          //                                     index) =>
                          //                                 AvailableNonSocketWidget(
                          //                               offers: cubit
                          //                                       .availableRideNonSocketData[
                          //                                   index],
                          //                             ),
                          //                             itemCount: cubit
                          //                                 .availableRideNonSocketData
                          //                                 .length,
                          //                             separatorBuilder: (context,
                          //                                     index) =>
                          //                                 const SizedBox(
                          //                                     height:
                          //                                         15),
                          //                           ))
                        )
                      // running Trips
                      else if (cubit.state.currentIndex == 1)
                        Expanded(
                            child: Stack(
                          children: [
                            if (state.tripStatus == TripState.accepted.name ||
                                state.tripStatus == TripState.goToClient.name ||
                                state.tripStatus == TripState.completed.name ||
                                state.tripStatus == TripState.inLocation.name ||
                                state.tripStatus == TripState.started.name ||
                                state.tripStatus == TripState.support.name)
                              _buildTopMap(context, state),
                            if(state.tripStatus == TripState.goToClient.name&&cubit.activeTrip?.driverIsArrivingIn!=null&&(cubit.activeTrip?.driverIsArrivingIn?.isNotEmpty??false)&&(DateTime.parse(cubit.activeTrip?.driverIsArrivingIn??'').toLocal().isAfter(DateTime.now())))
                              PositionedDirectional(
                                  top: 20.h,
                                  start: 100.w,
                                  end: 100.w,
                                  child: CountdownTimerCard(targetTime: DateTime.parse(cubit.activeTrip?.driverIsArrivingIn??'').toLocal(),)),
                            if ((cubit.activeTrip == null  || state.tripStatus == TripState.canceled.name || state.tripStatus == ''))
                              Center(
                                  child: Text(context.isArabic ? 'لا يوجد لديك رحلة جارية في الوقت الحالي' : "You don't have active trip at the moment",
                                      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 16))),
                            // DynamicMapWithPolyline(url: getMapUrl(context, type: "mapBox"), apiKey: getApiKey(context, type: "mapBox")),
                            if (state.tripStatus == TripState.goToClient.name)
                              BuildDriverArrivedSheet(
                                  onPressed: (String message) {
                                    ManageVibration.vibrate();
                                    cubit.arrivedToClient(context, cubit.activeTrip?.tripId ?? '', message);
                                  },
                                  onSafety: () {
                                    ManageVibration.vibrate();
                                    cubit.showSafety(state.tripStatus ?? '');
                                  },
                                  onCancelTrip: (CancelTripByRiderUseCaseParams params) {
                                    ManageVibration.vibrate();
                                    cubit.cancelDriverTrip(context: context, tripId: params.tripId, note: params.note, reasonId: params.reasonId, params: widget.params);
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
                                  cubit.cancelDriverTrip(context: context, tripId: params.tripId, note: params.note, reasonId: params.reasonId, params: widget.params);
                                },
                                params: widget.params,
                              ),
                            if (state.tripStatus == TripState.inLocation.name)
                              BuildDriverOtpSheet(
                                onPressed: (String otp) {
                                  ManageVibration.vibrate();
                                  cubit.startDriverTrip(context, cubit.activeTrip?.tripId ?? '', otp);
                                },
                                onCancelTrip: (CancelTripByRiderUseCaseParams params) {
                                  ManageVibration.vibrate();
                                  cubit.cancelDriverTrip(context: context, tripId: params.tripId, note: params.note, reasonId: params.reasonId, params: widget.params);
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
                                  cubit.finalizeTripByRider(context: context, tripId: cubit.activeTrip?.tripId ?? '', params: widget.params);
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
                                  cubit.stopRecord(context: context, subcategoryId: cubit.activeTrip?.subCategoryId ?? '', tripId: cubit.activeTrip?.tripId ?? '');
                                },
                                onCompleteRide: () {
                                  ManageVibration.vibrate();
                                  cubit.completeDriverTrip(context, cubit.activeTrip?.tripId ?? '', '');
                                },
                                onCompleteRideWithPrice: (String price) {
                                  ManageVibration.vibrate();
                                  cubit.completeDriverTripWithPrice(context, cubit.activeTrip?.tripId ?? '', price);
                                },
                                onCancelTrip: (CancelTripByRiderUseCaseParams params) {
                                  ManageVibration.vibrate();
                                  cubit.cancelDriverTrip(context: context, tripId: params.tripId, note: params.note, reasonId: params.reasonId, params: widget.params);
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
                                  cubit.rateTheClient(context: context, tripId: cubit.activeTrip?.tripId ?? '', comment: message, rate: rate, params: widget.params);
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
                        ))
                      // Past Trips
                      else if (cubit.state.currentIndex == 2)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: widget.params.modeType == "truck"
                                ? cubit.isLoadingHistoryNonSocketLoading
                                    ? const Center(child: CustomCircularProgressIndicator()) // supposed loading here
                                    : cubit.historyLoadingNonSocketData.isEmpty
                                        ? Center(
                                            child: Text(LocaleKeys.youDontHavePastOffer.localize),
                                          )
                                        : ListView.separated(
                                            itemBuilder: (context, index) => PastLoadingWidget(tripEntity: cubit.historyLoadingNonSocketData[index]),
                                            itemCount: cubit.historyLoadingNonSocketData.length,
                                            separatorBuilder: (context, index) => const SizedBox(height: 15),
                                          )
                                : widget.params.isSocket == false && widget.params.modeType == "ride"
                                    ? cubit.isLoadingMorePastNonSocketTrips
                                        ? const Center(child: CustomCircularProgressIndicator())
                                        : cubit.pastRideNonSocketData.isEmpty
                                            ? Center(child: Text(LocaleKeys.youDontHaveAcceptedOffer.localize))
                                            : ListView.builder(
                                                itemCount: cubit.pastRideNonSocketData.length,
                                                itemBuilder: (context, index) {
                                                  return ClickableWidget(
                                                    onTap: () {
                                                      ManageVibration.vibrate();
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => RideDashboardNonSocketDetailsScreen(
                                                                    tripEntity: cubit.pastRideNonSocketData[index],
                                                                  )));
/*
     final updatedLogsEntity = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider<RestaurantsCubit>(
                  create: (context) => serviceLocator<RestaurantsCubit>(),
                  child: LogDetailsScreen(logsEntity: orderData),
                ),
              ),
            );
            if (updatedLogsEntity != null) {
              context.read<RestaurantsCubit>().loadInitialReqLogs();
            }
 */
                                                    },
                                                    child: PastNonSocketTripsWidget(
                                                      tripEntity: cubit.pastRideNonSocketData[index],
                                                    ),
                                                  );
                                                })
                                    : cubit.isLoadingPastRideTrips
                                        ? const Center(child: CustomCircularProgressIndicator())
                                        : cubit.pastRideTrips.isEmpty
                                            ? Center(
                                                child: Text(context.isArabic ? "لا يوجد رحلات سابقة" : "No past trips"),
                                              )
                                            : ListView.builder(
                                                controller: _pastTripsScrollController,
                                                itemBuilder: (context, index) =>
                                                    PastTripsWidget(modeType: widget.params.isSocket == true ? 'ride' : 'truk', tripEntity: cubit.pastRideTrips[index]),
                                                itemCount: cubit.pastRideTrips.length,
                                              ),
                          ),
                        )
                      // Settings
                      else if (cubit.state.currentIndex == 3)
                        Expanded(
                          child: state.isLoadingSettings
                              ? Center(child: CustomCircularProgressIndicator())
                              : widget.params.isSocket == false && widget.params.modeType == "ride"
                                  ? SettingsNotSocket(settings: state.driverSettingsEntity)
                                  : widget.params.isSocket == false && widget.params.modeType == "truck"
                                      ? SettingsNotSocketLoading(settings: state.driverSettingLoadingEntity)
                                      : SettingsWidget(
                                          modeType: widget.params.isSocket == true ? 'ride' : 'truck',
                                          settings: state.settings,
                                        ),
                        )
                      /*
                            Expanded(
                              child: widget.params.isSocket == false && widget.params.modeType == "ride"
                                  ? state.isLoadingSettings
                                  ? const Center(child: CustomCircularProgressIndicator())
                                  : SettingsNotSocket(settings: state.driverSettingsEntity)
                                  : state.isLoadingSettings
                                  ? widget.params.isSocket == false &&
                                  widget.params.modeType == "truck"
                                  ? SettingsNotSocketLoading(
                                settings: state.driverSettingLoadingEntity,
                              )
                                  : const Center(child: CustomCircularProgressIndicator())
                                  : SettingsWidget(
                                modeType:
                                widget.params.isSocket == true ? 'ride' : 'truck',
                                settings: state.settings,
                              ),
                            )
*/
                      else if (cubit.state.currentIndex == 4)
                        Expanded(
                          child: cubit.isLoadingMoreAcceptedNonSocketTrips
                              ? const Center(child: CustomCircularProgressIndicator())
                              : widget.params.modeType == "truck"
                                  ? cubit.isLoadingAcceptedNonSocketLoading
                                      ? const Center(child: CustomCircularProgressIndicator()) // supposed loading here
                                      : cubit.acceptedLoadingNonSocketData.isEmpty
                                          ? Center(
                                              child: Text(LocaleKeys.youDontHaveAcceptedOffer.localize),
                                            )
                                          : ListView.separated(
                                              itemBuilder: (context, index) => AcceptedNonSocketLoadingWidget(offers: cubit.acceptedLoadingNonSocketData[index]),
                                              itemCount: cubit.acceptedLoadingNonSocketData.length,
                                              separatorBuilder: (context, index) => const SizedBox(height: 15),
                                            )
                                  : cubit.acceptedRideNonSocketData.isEmpty
                                      ? Center(child: Text(LocaleKeys.youDontHaveAcceptedOffer.localize))
                                      : ListView.builder(
                                          itemCount: cubit.acceptedRideNonSocketData.length,
                                          itemBuilder: (context, index) => Padding(
                                            padding: const EdgeInsetsDirectional.only(start: 16, end: 16, bottom: 16),
                                            child: AcceptedNonSocketWidget(
                                              offers: cubit.acceptedRideNonSocketData[index],
                                            ),
                                          ),
                                        ),
                        )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int currentIndex, int index, String title, GestureTapCallback? onTap) {
    return Expanded(
      flex: 3,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 30,
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppColors.PRIMARY_COLOR
                : context.isDarkMode
                    ? AppColors.GREY_DARK_COLOR
                    : AppColors.GREYBG,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: currentIndex == index
                    ? AppColors.whiteColor
                    : context.isDarkMode
                        ? AppColors.whiteColor
                        : AppColors.black,
                fontSize: 10,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterIcon(GestureTapCallback? onTap, int selectedIndex) {
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 30,
          decoration: BoxDecoration(
            color: selectedIndex == 3
                ? AppColors.PRIMARY_COLOR
                : context.isDarkMode
                    ? AppColors.GREY_DARK_COLOR
                    : AppColors.GREYBG,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.asset(
            Assets.option,
            color: selectedIndex == 3
                ? AppColors.whiteColor
                : context.isDarkMode
                    ? AppColors.whiteColor
                    : AppColors.black,
          ),
        ),
      ),
    );
  }

  final MapController _mapController = MapController();

  Widget _buildTopMap(BuildContext context, DashboardsState state) {
    List<gmap.LatLng> routePoints = [];
    routePoints = _convertPolylineToLatLng(context.read<DashboardsCubit>().activeTrip?.polyline ?? []);

    List<gmap.LatLng> clients = [];
    List<String> clientsAddress = [];
    if (context.read<DashboardsCubit>().activeTrip?.wayPointOne != null &&
        context.read<DashboardsCubit>().activeTrip?.wayPointOne?[0] != null &&
        context.read<DashboardsCubit>().activeTrip?.wayPointOne?[1] != null &&
        context.read<DashboardsCubit>().activeTrip?.wayPointOne?[0] != 0 &&
        context.read<DashboardsCubit>().activeTrip?.wayPointOne?[1] != 0) {
      clients.add(gmap.LatLng(context.read<DashboardsCubit>().activeTrip!.wayPointOne![0], context.read<DashboardsCubit>().activeTrip!.wayPointOne![1]));
    }

    if (context.read<DashboardsCubit>().activeTrip?.wayPointTwo != null &&
        context.read<DashboardsCubit>().activeTrip?.wayPointTwo?[0] != null &&
        context.read<DashboardsCubit>().activeTrip?.wayPointTwo?[1] != null &&
        context.read<DashboardsCubit>().activeTrip?.wayPointTwo?[0] != 0 &&
        context.read<DashboardsCubit>().activeTrip?.wayPointTwo?[1] != 0) {
      clients.add(gmap.LatLng(context.read<DashboardsCubit>().activeTrip!.wayPointTwo![0], context.read<DashboardsCubit>().activeTrip!.wayPointTwo![1]));
    }

    if (context.read<DashboardsCubit>().activeTrip?.wayPointOneTitle?.isNotEmpty ?? false) {
      clientsAddress.add(context.read<DashboardsCubit>().activeTrip?.wayPointOneTitle ?? '');
    }
    if (context.read<DashboardsCubit>().activeTrip?.wayPointTwoTitle?.isNotEmpty ?? false) {
      clientsAddress.add(context.read<DashboardsCubit>().activeTrip?.wayPointTwoTitle ?? '');
    }

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.grey,
      ),
      child: ClipRect(
        child: CustomGoogleMap(
          // key: ValueKey('map_${DateTime.now().millisecondsSinceEpoch}'), // Force rebuild
          startLocation: ((context.read<DashboardsCubit>().activeTrip?.startCoordinates == null) || (context.read<DashboardsCubit>().activeTrip?.startCoordinates == []))
              ? null
              : gmap.LatLng(context.read<DashboardsCubit>().activeTrip!.startCoordinates![1], context.read<DashboardsCubit>().activeTrip!.startCoordinates![0]),
          targetLocation: ((context.read<DashboardsCubit>().activeTrip?.targetCoordinates == null) || (context.read<DashboardsCubit>().activeTrip?.targetCoordinates == []))
              ? null
              : gmap.LatLng(context.read<DashboardsCubit>().activeTrip!.targetCoordinates![1], context.read<DashboardsCubit>().activeTrip!.targetCoordinates![0]),
          polylinePoints: routePoints,
          clientLocations: clients,
          enableScrolling: true,
          fromClient: (context.read<DashboardsCubit>().activeTrip != null && (state.tripStatus == TripState.started.name|| state.tripStatus == TripState.goToClient.name|| state.tripStatus == TripState.inLocation.name)) == true ? false : null,
          startAddress: context.read<DashboardsCubit>().activeTrip?.from,
          targetAddress: context.read<DashboardsCubit>().activeTrip?.to,
          clientAddresses: clientsAddress,
          estimatedTime: (context.read<DashboardsCubit>().state.tripStatus==TripState.goToClient.name||context.read<DashboardsCubit>().state.tripStatus==TripState.inLocation.name) ? DateFormat('h:mm a').format(DateTime.parse(context.read<DashboardsCubit>().activeTrip?.driverIsArrivingIn??'').toLocal()) :context.read<DashboardsCubit>().state.tripStatus==TripState.started.name ? DateFormat('h:mm a').format(DateTime.parse(context.read<DashboardsCubit>().activeTrip?.tripStartTime??'').toLocal().add(Duration(minutes:context.read<DashboardsCubit>().activeTrip?.duration??0 ))): '',
        ),
      ),
    );
  }

  List<gmap.LatLng> _convertPolylineToLatLng(List<List<double>> polyline) {
    return polyline.map((point) => gmap.LatLng(point[1], point[0])).toList();
  }
}
