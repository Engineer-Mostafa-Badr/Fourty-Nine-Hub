import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/client_trips_cubit/client_trips_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_loading_request_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_offers/past_ride_offer_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_offers/pending_ride_offer_screen.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_audio_streaming/zego_uikit_prebuilt_live_audio_room.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../res/style/styles.dart';
import 'accept_ride_offer_screen.dart';
import 'offer_ride_offer_screen.dart';

class MainTabsRideOffer extends StatefulWidget {
  const MainTabsRideOffer({super.key, this.type = 'ride'});
  final String? type;

  @override
  State<MainTabsRideOffer> createState() => _MainTabsRideOfferState();
}

class _MainTabsRideOfferState extends State<MainTabsRideOffer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabTitles = [
    LocaleKeys.offers.localize,
    LocaleKeys.accepted.localize,
    LocaleKeys.pending.localize,
    LocaleKeys.past.localize
  ];

  String selectedTap = 'ride';

  @override
  void initState() {
    super.initState();
    selectedTap = widget.type ?? 'ride';
    if (widget.type == 'ride')
      context.read<ClientTripsCubit>().loadInitialClientOfferTrips();
    if (widget.type == 'ride')
      context.read<ClientTripsCubit>().listenToUpdateOfferTripNonSocket();
    if (widget.type == 'shipping')
      context.read<ClientTripsCubit>().loadInitialClientOfferShippingTrips();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.isArabic ? 'وضع المستخدم' : 'User Mode',
          style: Styles.headerText(),
        ),
        elevation: 0,
        // Match your design
        shadowColor: Colors.transparent,
        shape: const Border(
          bottom: BorderSide(color: Colors.transparent, width: 0),
        ),
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(40),
        //   child: ,
        // ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    radius: 15,
                    label: LocaleKeys.ride.tr(),
                    onPressed: () {
                      if (selectedTap != 'ride') {
                        setState(() {
                          selectedTap = 'ride';
                        });

                        if (_tabController.index == 2) {
                          // if (widget.type == 'ride')
                          context
                              .read<ClientTripsCubit>()
                              .loadInitialClientPendingTrips();
                          // if (widget.type == 'shipping') context.read<ClientTripsCubit>().loadInitialClientPendingShippingTrips();
                        }
                        if (_tabController.index == 1) {
                          // if (selectedTap == 'ride')
                          context
                              .read<ClientTripsCubit>()
                              .loadInitialClientAcceptedTrips();
                          // if (selectedTap == 'shipping')context.read<ClientTripsCubit>().loadInitialClientAcceptedShippingTrips();
                        }
                        if (_tabController.index == 0) {
                          // if (selectedTap == 'ride')
                          context
                              .read<ClientTripsCubit>()
                              .loadInitialClientOfferTrips();
                          // if (selectedTap == 'shipping')context.read<ClientTripsCubit>().loadInitialClientOfferShippingTrips();
                        }
                        if (_tabController.index == 3) {
                          print("object");
                          // if (selectedTap == 'ride')
                          context
                              .read<ClientTripsCubit>()
                              .loadInitialClientPastTrips();
                          // if (selectedTap == 'shipping')context.read<ClientTripsCubit>().loadInitialClientPastShippingTrips();
                        }
                      }
                    },
                    backColor: selectedTap == 'ride'
                        ? AppColors.SECONDARY_COLOR
                        : AppColors.PRIMARY_COLOR,
                  ),
                ),
                Sizer(),
                Expanded(
                  child: AppButton(
                    color: AppColors.whiteColor,
                    // color: selectedTap=='shipping'?AppColors.whiteColor:AppColors.whiteColor,
                    radius: 15,
                    label: context.isArabic ? 'تحميله' : 'Shipping',
                    onPressed: () {
                      if (selectedTap != 'shipping') {
                        setState(() {
                          selectedTap = 'shipping';
                        });
                        if (_tabController.index == 2) {
                          // if (selectedTap == 'ride') context.read<ClientTripsCubit>().loadInitialClientPendingTrips();
                          // if (selectedTap == 'shipping')
                          context
                              .read<ClientTripsCubit>()
                              .loadInitialClientPendingShippingTrips();
                        }
                        if (_tabController.index == 1) {
                          // if (selectedTap == 'ride')context.read<ClientTripsCubit>().loadInitialClientAcceptedTrips();
                          // if (selectedTap == 'shipping')
                          context
                              .read<ClientTripsCubit>()
                              .loadInitialClientAcceptedShippingTrips();
                        }
                        if (_tabController.index == 0) {
                          // if (selectedTap == 'ride')context.read<ClientTripsCubit>().loadInitialClientOfferTrips();
                          // if (selectedTap == 'shipping')
                          context
                              .read<ClientTripsCubit>()
                              .loadInitialClientOfferShippingTrips();
                        }
                        if (_tabController.index == 3) {
                          print("object");
                          // if (selectedTap == 'ride')context.read<ClientTripsCubit>().loadInitialClientPastTrips();
                          // if (selectedTap == 'shipping')
                          context
                              .read<ClientTripsCubit>()
                              .loadInitialClientPastShippingTrips();
                        }
                      }
                    },
                    backColor: selectedTap == 'shipping'
                        ? AppColors.SECONDARY_COLOR
                        : AppColors.PRIMARY_COLOR,
                  ),
                ),
              ],
            ),
          ),
          Sizer(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                OfferRideOfferScreen(
                  type: selectedTap,
                ),
                AcceptRideOfferScreen(
                  type: selectedTap,
                ),
                PendingRideOfferScreen(
                  type: selectedTap,
                ),
                PastRideOfferScreen(
                  type: selectedTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 16),
      height: 40,
      child: TabBar(
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        controller: _tabController,
        isScrollable: true,
        indicator: const BoxDecoration(color: Colors.transparent),
        // No underline
        labelPadding: EdgeInsets.zero,
        onTap: (index) {
          if (index == 2) {
            // loadInitialClientAcceptedShippingTrips
            if (selectedTap == 'ride')
              context.read<ClientTripsCubit>().loadInitialClientPendingTrips();
            if (selectedTap == 'shipping')
              context
                  .read<ClientTripsCubit>()
                  .loadInitialClientPendingShippingTrips();
          }
          if (index == 1) {
            print("object1");
            if (selectedTap == 'ride')
              context.read<ClientTripsCubit>().loadInitialClientAcceptedTrips();
            if (selectedTap == 'shipping')
              context
                  .read<ClientTripsCubit>()
                  .loadInitialClientAcceptedShippingTrips();
          }
          if (index == 0) {
            if (selectedTap == 'ride')
              context.read<ClientTripsCubit>().loadInitialClientOfferTrips();
            if (selectedTap == 'shipping')
              context
                  .read<ClientTripsCubit>()
                  .loadInitialClientOfferShippingTrips();
          }
          if (index == 3) {
            print("object");
            if (selectedTap == 'ride')
              context.read<ClientTripsCubit>().loadInitialClientPastTrips();
            if (selectedTap == 'shipping')
              context
                  .read<ClientTripsCubit>()
                  .loadInitialClientPastShippingTrips();
          }

          // if (index == 0) {
          //   _loadInitialClientOfferTrips();
          // }
          // if (index == 2) {
          //   _loadInitialClientAcceptedTrips();
          // }
          // if (index == 3) {
          //   _loadInitialClientPastTrips();
          // }
          setState(() {});
        },
        tabs: List.generate(_tabTitles.length, (index) {
          final isSelected = _tabController.index == index;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: Tab(
              child: Container(
                width: 200.w,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.PRIMARY_COLOR
                      : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  _tabTitles[index],
                  style: Styles.mediumText(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
