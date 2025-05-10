import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/client_trips_cubit/client_trips_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_loading_request_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_offers/past_ride_offer_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_offers/pending_ride_offer_screen.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_audio_streaming/zego_uikit_prebuilt_live_audio_room.dart';

import '../../../../../res/style/styles.dart';
import 'accept_ride_offer_screen.dart';
import 'offer_ride_offer_screen.dart';

class MainTabsRideOffer extends StatefulWidget {
  const MainTabsRideOffer({super.key});

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
  }

  void _loadInitialClientPendingTrips() {
    print("✅ loadInitialClientPendingTrips called");
    context.read<ClientTripsCubit>()..loadInitialClientAcceptedTrips();
  }
  void _loadInitialClientOfferTrips() {
    print("✅ loadInitialClientOfferTrips called");
    context.read<ClientTripsCubit>()..loadInitialClientOfferTrips();
  }
  void _loadInitialClientPastTrips() {
    print("✅ loadInitialClientPastTrips called");
    context.read<ClientTripsCubit>()..loadInitialClientPastTrips();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Add this line
      appBar: AppBar(
        title: Text(
          LocaleKeys.rideOffer.localize,
          style: Styles.headerText(),
        ),
        elevation: 0,
        // Match your design
        shadowColor: Colors.transparent,
        shape: const Border(
          bottom: BorderSide(color: Colors.transparent, width: 0),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: _buildTabBar(),
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          OfferRideOfferScreen(),
          AcceptRideOfferScreen(),
          PendingRideOfferScreen(),
          PastRideOfferScreen(),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 16.w),
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
          if (index == 1) {
            _loadInitialClientPendingTrips();
          }
          if (index == 0) {
            _loadInitialClientOfferTrips();
          }
          if (index == 3) {
            _loadInitialClientPastTrips();
          }
          setState(() {});
        },
        tabs: List.generate(_tabTitles.length, (index) {
          final isSelected = _tabController.index == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Tab(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF0D0C3F)
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
