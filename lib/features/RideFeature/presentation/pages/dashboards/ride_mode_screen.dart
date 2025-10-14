import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/banner.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/ride_dashboard_non_socket_details_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/available_ride_trip_item.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/settings_not_socket_loading.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/tracking_active_trip.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/settings_not_socket.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/available_non_socket_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:fourtyninehub/shared_web_socket.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../controllers/dashboards_cubit/dashboards_cubit.dart';
import '../loading_dashboard/accepted_non_socket_loading.dart';
import '../loading_dashboard/available_loading_widget.dart';
import '../loading_dashboard/past_loading_widget.dart';
import '../widgets/accepted_non_socket_widget.dart';
import '../widgets/past_trip_non_socket_widget.dart';
import 'widgets/not_ready_available_trips_widget.dart';
import 'widgets/past_trips_widget.dart';
import 'widgets/settings_widget.dart';

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
  late ScrollController _availableTruckTripsScrollController;
  late ScrollController _currentTruckTripsScrollController;
  late ScrollController _pastTruckTripsScrollController;
  late ScrollController availableScrollController;
  late ScrollController pastScrollController;
  late ScrollController _pastTripsScrollController;

  @override
  dispose() {
    SharedWebSocket.socket!.off("REID:NEW_AVAILABLE_TRIP");
    SharedWebSocket.socket!.off("RIDE:NON_TRACKING_TRIPS_UPDATED");
    SharedWebSocket.socket!.off("RIDE:REMOVE_TRIP_FROM_LIST");
    SharedWebSocket.socket!.off("LOADING:NEW_TRIP");
    SharedWebSocket.socket!.off("LOADING:CANCELED_LOADING_TRIP");
    SharedWebSocket.socket!.off("LOADING:ACCEPTED_TRIP_OFFER");
    SharedWebSocket.socket!.off("LOADING:REMOVE_TRIP");
    var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    currentContext.read<MainCategoriesCubit>().listenToNewTrip(currentContext, currentContext.read<MainCategoriesCubit>().state.setting?.data.enableNotificationSound ?? false);
    debugPrint("dispose REID:NEW_AVAILABLE_TRIP");
    super.dispose();
  }

  @override
  void initState() {
    SharedWebSocket.socket!.off("REID:NEW_AVAILABLE_TRIP");
    debugPrint("widget.params.isSocket ${widget.params.isSocket}");
    super.initState();
    availableScrollController = ScrollController();
    pastScrollController = ScrollController();
    _availableTripsScrollController = ScrollController()..addListener(_onScroll);
    _availableTruckTripsScrollController = ScrollController();
    _currentTruckTripsScrollController = ScrollController();
    _pastTruckTripsScrollController = ScrollController();
    _pastTripsScrollController = ScrollController()..addListener(_onScrollPastTrips);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardCubit = context.read<DashboardsCubit>();
      // if (!dashboardCubit.isClosed) {
      widget.params.isSocket == true && widget.params.modeType == "ride"
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
          : widget.params.isSocket == false && widget.params.modeType == "ride"
              ? [
                  dashboardCubit.loadInitialAvailableNonSocketTrips(),
                  dashboardCubit.listenToRemoveUntrackedTrip(),
                  dashboardCubit.listenToNewTripNonSocket(widget.params),
                  dashboardCubit.listenToAcceptTripOfferTrip(4, context, widget.params),
                  dashboardCubit.getDriverSettings(context),
                ]
              : widget.params.modeType == "truck"
                  ? [
                      dashboardCubit.loadInitialAvailableNonSocketLoading(),
                      dashboardCubit.listenToRemoveLoading(),
                      dashboardCubit.listenToNewLoading(),
                      dashboardCubit.listenToAcceptTripOfferLoading(4, context, widget.params),
                      dashboardCubit.listenToRemoveAcceptedTripOfferLoading(),
                    ]
                  : [];
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
      debugPrint("object");
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
          onBackPressed: () => context.pop(),
          body: NestedAppbar(
            scrollController: _scrollController,
            appBars: const [],
            body: BlocConsumer<DashboardsCubit, DashboardsState>(
              listener: (context, state) {},
              builder: (context, state) {
                var cubit = context.read<DashboardsCubit>();
                debugPrint("state.tripStatus ${state.tripStatus}");
                debugPrint("cubit.activeTrip?.driverIsArrivingIn ${cubit.activeTrip?.driverIsArrivingIn}");

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
                                                      child: CustomEmptyWidget(
                                                        label: LocaleKeys.youDontHaveAvailableOffer.localize,
                                                      ),
                                                    )
                                                  : OlxPaginationWidget(
                                                      items: List.generate(cubit.availableLoadingNonSocketData.length,
                                                          (index) => AvailableNonSocketLoadingWidget(offers: cubit.availableLoadingNonSocketData[index])),
                                    itemsPerPage: 3,
                                                      banners: bannersList,
                                                      loadPage: (page) {
                                                        return cubit.getAvailableNonSocketLoading();
                                                      },
                                                      scrollController: _availableTruckTripsScrollController,
                                                    )
                                          : widget.params.isSocket == true
                                              ? cubit.isLoadingAvailableRideTrips
                                                  ? const Center(child: CustomCircularProgressIndicator())
                                                  : cubit.availableRideTrips.isNotEmpty
                                                      ? OlxPaginationWidget(
                                                          itemsPerPage: 2,
                                                          loadPage: (page) {
                                                            debugPrint('==> page $page');
                                                            return context
                                                                .read<DashboardsCubit>()
                                                                .getPastTrips(context, widget.params.isSocket == true ? "tracking" : 'non-tracking');
                                                          },
                                                          banners: bannersList,
                                                          items: List.generate(
                                                              cubit.availableRideTrips.length,
                                                              (index) => AvailableRideTripItem(
                                                                    tripEntity: cubit.availableRideTrips[index],
                                                                    onRefuseTrip: (String id) {
                                                                      ManageVibration.vibrate();
                                                                      cubit.refuseTripOffer(id);
                                                                    },
                                                                    params: widget.params,
                                                                  )),
                                                          scrollController: availableScrollController,
                                                        )
                                                      : Center(
                                                          child: CustomEmptyWidget(
                                                            label:context.isArabic ? 'لا يوجد رحلات متاحة' : 'No Available Trips',
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
                                                          ? Center(child: CustomEmptyWidget(label: LocaleKeys.youDontHaveAvailableOffer.localize))
                                                          : OlxPaginationWidget(
                                                              items: List.generate(
                                                                  cubit.availableRideNonSocketData.length,
                                                                  (i) => Padding(
                                                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                        child: AvailableNonSocketWidget(
                                                                          offers: cubit.availableRideNonSocketData[i],
                                                                        ),
                                                                      )),
                                                              banners: bannersList,
                                                              itemsPerPage: 3,
                                                              loadPage: (page) {
                                                                return context.read<DashboardsCubit>().getAvailableNonSocketTrips();
                                                              },
                                                              scrollController: _availableTripsScrollController)
                                                      // ListView.separated(
                                                      //                             controller: _availableTripsScrollController,
                                                      //                             itemBuilder: (context, index) => AvailableNonSocketWidget(
                                                      //                               offers: cubit.availableRideNonSocketData[index],
                                                      //                             ),
                                                      //                             itemCount: cubit.availableRideNonSocketData.length,
                                                      //                             separatorBuilder: (context, index) => const SizedBox(height: 15),
                                                      //                           )
                                                      )))
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
                        TrackingActiveTrip(
                          params: widget.params,
                        )
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
                                            child: CustomEmptyWidget(label: LocaleKeys.youDontHavePastOffer.localize),
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
                                            ? Center(child: CustomEmptyWidget(label: LocaleKeys.youDontHaveAcceptedOffer.localize))
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
                                            : OlxPaginationWidget(
                                                itemsPerPage: 3,
                                                loadPage: (page) {
                                                  debugPrint('==> page $page');
                                                  return context.read<DashboardsCubit>().getPastTrips(context, widget.params.isSocket == true ? "tracking" : 'non-tracking');
                                                },
                                                banners: bannersList,
                                                items: List.generate(cubit.pastRideTrips.length,
                                                    (index) => PastTripsWidget(modeType: widget.params.isSocket == true ? 'ride' : 'truk', tripEntity: cubit.pastRideTrips[index])),
                                                scrollController: pastScrollController,
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
                                      : SettingsWidget(modeType: widget.params.isSocket == true ? 'ride' : 'truck', settings: state.settings, params: widget.params),
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
                                              child: CustomEmptyWidget(label: LocaleKeys.youDontHaveAcceptedOffer.localize),
                                            )
                                          : OlxPaginationWidget(
                                              items: List.generate(cubit.acceptedLoadingNonSocketData.length,
                                                  (index) => AcceptedNonSocketLoadingWidget(offers: cubit.acceptedLoadingNonSocketData[index])),
                                              banners: bannersList,
                                              itemsPerPage: 3,
                                              loadPage: (page) {
                                                return cubit.getAcceptedNonSocketLoading();
                                              },
                                              scrollController: _currentTruckTripsScrollController,
                                            )
                                  : cubit.acceptedRideNonSocketData.isEmpty
                                      ? Center(child: CustomEmptyWidget(label: LocaleKeys.youDontHaveAcceptedOffer.localize))
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
        // child: TabWidget(),
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
}
