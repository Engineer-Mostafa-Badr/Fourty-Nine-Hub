import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/enums/trip_states_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_support_details_usecase.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/ride_dashboard_details_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/ride_dashboard_non_socket_details_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/available_ride_trip_item.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_driver_arrived_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_driver_otp_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_driver_complete_trip_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_driver_rate_client_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_go_to_client_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/build_safety_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_home.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/support_ride_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/settings_not_socket.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/available_non_socket_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
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
import '../ride_details_screen.dart';
import '../widgets/accepted_non_socket_widget.dart';
import '../widgets/map_section.dart';
import '../widgets/past_trip_non_socket_widget.dart';
import 'widgets/not_ready_available_trips_widget.dart';
import 'widgets/past_trips_widget.dart';
import 'widgets/settings_widget.dart';
import 'widgets/truk_bus_widget.dart';

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
  void initState() {
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
              dashboardCubit.listenToNewTrip(),
              dashboardCubit.listenToRemoveTrip(),
              dashboardCubit.listenToEndTrip(context, widget.params),
            ]
          : [
              dashboardCubit.loadInitialAvailableNonSocketTrips(),
              dashboardCubit.listenToRemoveUntrackedTrip(),
              dashboardCubit.listenToNewTripNonSocket(),
              dashboardCubit.listenToAcceptTripOfferTrip(4, context, widget.params),
              dashboardCubit.getDriverSettings(context),
            ];
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      widget.params.isSocket == true && widget.params.currentIndex == 0
          ? context.read<DashboardsCubit>().getAvailableRideTrips(context)
          : context.read<DashboardsCubit>().getAvailableNonSocketTrips();
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
                                  cubit.changeIndex(1, context, widget.params);
                                  // setState(() {
                                  //   _selectedIndex = 1;
                                  // });
                                },
                              ),
                            if (widget.params.isSocket == false && widget.params.modeType == "ride")
                              _buildTabItem(
                                cubit.state.currentIndex ?? 0,
                                4,
                                LocaleKeys.current.localize,
                                () {
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
                                cubit.changeIndex(2, context, widget.params);
                                // setState(() {
                                //   _selectedIndex = 2;
                                // });
                              },
                            ),
                            _buildFilterIcon(() {
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
                                      : widget.params.isSocket == true
                                          ? cubit.isLoadingAvailableRideTrips
                                              ? const Center(child: CustomCircularProgressIndicator())
                                              : cubit.availableRideTrips.isNotEmpty
                                                  ? Column(
                                                      children: [
                                                        Expanded(
                                                          child: ListView.separated(
                                                              controller: _availableTripsScrollController,
                                                              itemBuilder: (context, index) => AvailableRideTripItem(tripEntity: cubit.availableRideTrips[index], onRefuseTrip: (String id) {
                                                                cubit.refuseTripOffer(id);
                                                              },),
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
                            _buildTopMap(context, state),
                            // DynamicMapWithPolyline(url: getMapUrl(context, type: "mapBox"), apiKey: getApiKey(context, type: "mapBox")),
                            if (state.tripStatus == TripState.goToClient.name)
                              BuildDriverArrivedSheet(
                                  onPressed: (String message) {
                                    cubit.arrivedToClient(context, state.activeTrip?.tripId ?? '', message);
                                  },
                                  onSafety: () {
                                    cubit.showSafety(state.tripStatus ?? '');
                                  },
                                  activeTrip: state.activeTrip),
                            if (state.tripStatus == TripState.accepted.name)
                              BuildGoToClientSheet(
                                onGoingToClient: () {
                                  cubit.goingToClient(context, state.activeTrip?.tripId ?? '');
                                },
                                activeTrip: state.activeTrip,
                                onSafety: () {
                                  cubit.showSafety(state.tripStatus ?? '');
                                },
                              ),
                            if (state.tripStatus == TripState.inLocation.name)
                              BuildDriverOtpSheet(
                                onPressed: (String otp) {
                                  cubit.startDriverTrip(context, state.activeTrip?.tripId ?? '', otp);
                                },
                                onSafety: () {
                                  cubit.showSafety(state.tripStatus ?? '');
                                },
                                onTick: (Duration time) {
                                  DateTime future = DateTime.now().add(time);
                                  cubit.updateRemainingTime(future);
                                },
                                onFinalizeTrip: () {
                                  cubit.finalizeTripByRider(context: context, tripId: state.activeTrip?.tripId ?? '');
                                },
                                remainingTime: state.remainingTime,
                                activeTrip: state.activeTrip,
                              ),
                            if (state.tripStatus == TripState.started.name)
                              BuildDriverCompleteTripSheet(
                                onPressed: (String) {},
                                onStartRecord: () {
                                  cubit.startRecord();
                                },
                                onStopRecord: () {
                                  cubit.stopRecord(context: context, subcategoryId: state.activeTrip?.subCategoryId ?? '', tripId: state.activeTrip?.tripId ?? '');
                                },
                                onCompleteRide: () {
                                  cubit.completeDriverTrip(context, state.activeTrip?.tripId ?? '', '');
                                },
                                onCompleteRideWithPrice: (String price) {
                                  cubit.completeDriverTripWithPrice(context, state.activeTrip?.tripId ?? '', price);
                                },
                                tripId: state.activeTrip?.tripId ?? '',
                              ),
                            if (state.tripStatus == TripState.completed.name)
                              BuildDriverRateClientSheet(
                                onPressed: (message, rate) {
                                  print("message $message ||| rate $rate");
                                  cubit.rateTheClient(context: context, tripId: state.activeTrip?.tripId ?? '', comment: message, rate: rate);
                                },
                              ),
                            if (state.tripStatus == TripState.support.name)
                              BuildSafetySheet(params: SupportRideParams(
                                  tripId: state.activeTrip?.tripId ?? '',
                                  tripType: 'tracing',
                                  userType: 'driver',
                                  driverId: state.activeTrip?.driverId ?? '',
                                  clientId: state.activeTrip?.clientId ?? ''),
                                onClose: (){
                                cubit.closeSafety();
                              }, supportRideScreen: () {
                                context.push(Routes.supportRideScreen, extra: SupportRideParams(tripId: state.activeTrip?.tripId??'', tripType: 'tracing', userType: 'driver', driverId: state.activeTrip?.driverId??'',clientId: state.activeTrip?.clientId??'',),);
                              },
                                emergencyContactsScreen: (){
                                  context.push(Routes.emergencyContactsScreen);
                                },
                                rideFindingScreen: (){
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
                            child: widget.params.isSocket == false && widget.params.modeType == "ride"
                                ? cubit.isLoadingMorePastNonSocketTrips
                                    ? const Center(child: CustomCircularProgressIndicator())
                                    : cubit.pastRideNonSocketData.isEmpty
                                        ? Center(child: Text(LocaleKeys.youDontHaveAcceptedOffer.localize))
                                        : ListView.builder(
                                            itemCount: 0,
                                            itemBuilder: (context, index) {
                                              return ClickableWidget(
                                                onTap: () {
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
                            child: widget.params.isSocket == false && widget.params.modeType == "ride"
                                ? state.isLoadingSettings
                                    ? const Center(child: CustomCircularProgressIndicator())
                                    : SettingsNotSocket(settings: state.driverSettingsEntity)
                                : state.isLoadingSettings
                                    ? const Center(child: CustomCircularProgressIndicator())
                                    : SettingsWidget(modeType: widget.params.isSocket == true ? 'ride' : 'truk', settings: state.settings))
                      else if (cubit.state.currentIndex == 4)
                        Expanded(
                          child: cubit.isLoadingMoreAcceptedNonSocketTrips
                              ? const Center(child: CustomCircularProgressIndicator())
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
            color: currentIndex == index ? AppColors.PRIMARY_COLOR : AppColors.GREYBG,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: currentIndex == index ? AppColors.whiteColor : AppColors.black, fontSize: 10, fontWeight: FontWeight.w600),
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
            color: selectedIndex == 3 ? AppColors.PRIMARY_COLOR : AppColors.GREYBG,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.asset(
            Assets.option,
            color: selectedIndex == 3 ? AppColors.whiteColor : AppColors.black,
          ),
        ),
      ),
    );
  }
  final MapController _mapController = MapController();

  Widget _buildTopMap(BuildContext context, DashboardsState state) {
    List<LatLng> routePoints = [];
    routePoints =
        _convertPolylineToLatLng(state.activeTrip?.polyline ?? []);

    if (state.activeTrip != null &&
        state.activeTrip?.startCoordinates?[0] == null &&
        state.activeTrip?.startCoordinates?[1] == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(
          LatLng(state.activeTrip!.startCoordinates![0], state.activeTrip!.startCoordinates![1]),
          12.0,
        );
      });
    }else{
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(
          LatLng( 30.033333, 31.233334),
          12.0,
        );
      });
    }

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: FlutterMap(
        mapController: _mapController,
        options: (state.activeTrip != null &&
            state.activeTrip?.startCoordinates?[0] == null &&
            state.activeTrip?.startCoordinates?[1] == null &&
            state.activeTrip?.startCoordinates?[0] != 0 &&
            state.activeTrip?.startCoordinates?[1] != 0)? MapOptions(
          initialCenter: LatLng(state.activeTrip!.startCoordinates![0], state.activeTrip!.startCoordinates![1]),
          initialZoom: 12.0,
        ) : MapOptions(
          initialCenter: LatLng( 30.033333, 31.233334),
          initialZoom: 12.0,
        ),
        children: [
          TileLayer(
            // urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            // urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
            // urlTemplate: "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",
            urlTemplate: context.isDarkMode
                ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png" // Dark mode map
                : "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png", // Normal mode map
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              if (state.activeTrip != null &&
                  state.activeTrip?.startCoordinates?[0] != null &&
                  state.activeTrip?.startCoordinates?[1] != null &&
                  state.activeTrip?.startCoordinates?[0] != 0 &&
                  state.activeTrip?.startCoordinates?[1] != 0)
                Marker(
                  point: LatLng(state.activeTrip!.startCoordinates![0], state.activeTrip!.startCoordinates![1]),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin,
                      color: Colors.green, size: 40),
                ),
              if (state.activeTrip?.targetCoordinates != null && state.activeTrip?.targetCoordinates?[0] != null && state.activeTrip?.targetCoordinates?[1] != null && state.activeTrip?.targetCoordinates?[0] != 0 && state.activeTrip?.targetCoordinates?[1] != 0)
                Marker(
                  point: LatLng(state.activeTrip!.targetCoordinates![0], state.activeTrip!.targetCoordinates![1]),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin,
                      color: Colors.blue, size: 40),
                ),
              if (state.activeTrip?.wayPointOne != null && state.activeTrip?.wayPointOne?[0] != null && state.activeTrip?.wayPointOne?[1] != null && state.activeTrip?.wayPointOne?[0] != 0 && state.activeTrip?.wayPointOne?[1] != 0)
                Marker(
                  point:
                  LatLng(state.activeTrip!.wayPointOne![0], state.activeTrip!.wayPointOne![1]),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin,
                      color: Colors.red, size: 40),
                ),
              if (state.activeTrip?.wayPointTwo != null && state.activeTrip?.wayPointTwo?[0] != null && state.activeTrip?.wayPointTwo?[1] != null && state.activeTrip?.wayPointTwo?[0] != 0 && state.activeTrip?.wayPointTwo?[1] != 0)
                Marker(
                  point:
                  LatLng(state.activeTrip!.wayPointTwo![0], state.activeTrip!.wayPointTwo![1]),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin,
                      color: Colors.red, size: 40),
                ),
            ],
          ),

              BlocBuilder<DashboardsCubit, DashboardsState>(builder: (context, state) {
                if (state.tripStatus == TripState.started.name) {
                  return const CarMarkerWidget();
                }
                return const SizedBox.shrink();
              }),
          if (routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints,
                  color: context.isDarkMode ? Colors.blue :  Colors.black87,
                  strokeWidth: 4.0,
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<LatLng> _convertPolylineToLatLng(List<List<double>> polyline) {
    return polyline.map((point) => LatLng(point[1], point[0])).toList();
  }
}
