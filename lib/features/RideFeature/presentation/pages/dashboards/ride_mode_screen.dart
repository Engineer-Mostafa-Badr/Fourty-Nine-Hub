import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/available_ride_trip_item.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../carpool/add_new_route/presentation/widgets/dynamic_map_test.dart';
import '../../controllers/dashboards_cubit/dashboards_cubit.dart';
import '../widgets/map_section.dart';
import 'widgets/not_ready_available_trips_widget.dart';
import 'widgets/past_trips_widget.dart';
import 'widgets/settings_widget.dart';
import 'widgets/truk_bus_widget.dart';

class RideModeParams {
  final String modeType;
  final bool? isSocket;
  const RideModeParams({required this.modeType, this.isSocket});
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
  int _selectedIndex = 0;

  @override
  void initState() {
    print("widget.params.isSocket ${widget.params.isSocket}");
    super.initState();
    _availableTripsScrollController = ScrollController()
      ..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardCubit = context.read<DashboardsCubit>();
      // if (!dashboardCubit.isClosed) {
        widget.params.isSocket == true
            ? [dashboardCubit.loadAvailableRideTrips(context),dashboardCubit.listenToUpdateTripAutoAccept(),dashboardCubit.listenToUpdateTripPrice(),dashboardCubit.listenToAcceptOffer(),dashboardCubit.listenToNewTrip()]
            : dashboardCubit.getAvailableTrips(context);
        dashboardCubit.getPastTrips(context,
            widget.params.isSocket == true ? "tracking" : 'non-tracking');
        dashboardCubit.getSettings(context);
      // }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.params.isSocket == true
          ? context.read<DashboardsCubit>().getAvailableRideTrips(context)
          : context.read<DashboardsCubit>().getAvailableTrips(context);
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
            body: BlocBuilder<DashboardsCubit, DashboardsState>(
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
                                  widget.params.isSocket == true
                                      ? LocaleKeys.rideMode.tr()
                                      // : widget.params.modeType == 'truk'?
                                      : LocaleKeys.trukMode.tr(),
                                  // : LocaleKeys.busMode.tr(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
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
                            _buildTabItem(0, LocaleKeys.availableTrips.tr()),
                            if (widget.params.isSocket == true)
                              _buildTabItem(1, LocaleKeys.runningTrips.tr()),
                            _buildTabItem(2, LocaleKeys.pastTrips.tr()),
                            if (widget.params.isSocket == false)
                              _buildTabItem(4, LocaleKeys.loadingRequest.tr()),
                            _buildFilterIcon(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Available Trips
                      if (_selectedIndex == 0)
                        Expanded(
                          child: (state.settings?.isReady ?? true)
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: state.isLoadingAvailable
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      :
                                      //     : state.isError
                                      //         ? Center(
                                      //             child: Text("Error: ${state.failure}"))
                                      //         :
                                      // !state.isSuccess ||
                                      widget.params.isSocket == true
                                          ? cubit.isLoadingMore
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : state.availableRideTrips != null
                                                  ? ListView.separated(
                                                      controller:
                                                          _availableTripsScrollController,
                                                      itemBuilder: (context, index) =>
                                                          AvailableRideTripItem(
                                                              tripEntity: state.availableRideTrips![
                                                                  index]),
                                                      itemCount: state
                                                          .availableRideTrips!
                                                          .length,
                                                      separatorBuilder:
                                                          (BuildContext context, int index) =>
                                                              const SizedBox(
                                                                  height: 15))
                                                  : const SizedBox.shrink()
                                          : state.availableTrips == null
                                              ? Container()
                                              : ListView.separated(
                                                  controller:
                                                      _availableTripsScrollController,
                                                  itemBuilder: (context, index) =>
                                                      TrukBusWidget(
                                                        tripEntity: state
                                                                .availableTrips![
                                                            index],
                                                        isWithAnotherPrice:
                                                            !state
                                                                .availableTrips![
                                                                    index]
                                                                .tripDetails!
                                                                .autoAccept,
                                                        modeType: 'bus',
                                                      ),
                                                  // : const TrukBusWidget(),
                                                  itemCount: state
                                                      .availableTrips!.length,
                                                  separatorBuilder: (BuildContext context, int index) =>
                                                      const SizedBox(height: 15)),
                                )
                              : const NotReadyAvailableTripsWidget(),
                        )
                      // running Trips
                      else if (_selectedIndex == 1)
                        Expanded(child: DynamicMapWithPolyline(url: getMapUrl(context, type: "mapBox"), apiKey: getApiKey(context, type: "mapBox")))
                      // Past Trips
                      else if (_selectedIndex == 2)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: state.isLoadingPast
                                ? const Center(child: CircularProgressIndicator())
                                :
                                //     : state.isError
                                //         ? Center(
                                //             child: Text("Error: ${state.failure}"))
                                //         : !state.isSuccess ||
                                state.pastTrips == null
                                    ? Container()
                                    : ListView.builder(
                                        itemBuilder: (context, index) =>
                                            PastTripsWidget(
                                                modeType:
                                                    widget.params.isSocket ==
                                                            true
                                                        ? 'ride'
                                                        : 'truk',
                                                tripEntity:
                                                    state.pastTrips![index]),
                                        itemCount: state.pastTrips!.length,
                                      ),
                          ),
                        )
                      // Settings
                      else if (_selectedIndex == 3)
                        Expanded(
                            child: state.isLoadingSettings
                                ? const Center(child: CircularProgressIndicator())
                                :
                                //     : state.isError
                                //         ? Center(
                                //             child: Text("Error: ${state.failure}"))
                                //         :
                                // !state.isSuccess ||
                                SettingsWidget(
                                    modeType: widget.params.isSocket == true
                                        ? 'ride'
                                        : 'truk',
                                    settings: state.settings))
                      // Ride or Loading Trips
                      else if (_selectedIndex == 4)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ListView.separated(
                                itemBuilder: (context, index) => const TrukBusWidget(modeType: 'bus', isWithAnotherPrice: true),
                                itemCount: 2,
                                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 15)),
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

  Widget _buildTabItem(int index, String title) {
    return Expanded(
      flex: 3,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            widget.params.isSocket == true
                ? context.read<DashboardsCubit>().loadAvailableRideTrips(context)
                : context.read<DashboardsCubit>().getAvailableTrips(context);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 30,
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
            color: _selectedIndex == index ? AppColors.PRIMARY_COLOR : AppColors.GREYBG,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: _selectedIndex == index ? AppColors.whiteColor : AppColors.black, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterIcon() {
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = 3;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 30,
          decoration: BoxDecoration(
            color: _selectedIndex == 3 ? AppColors.PRIMARY_COLOR : AppColors.GREYBG,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.asset(
            Assets.option,
            color: _selectedIndex == 3 ? AppColors.whiteColor : AppColors.black,
          ),
        ),
      ),
    );
  }
}
