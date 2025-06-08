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

  String selectedTap = 'ride';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        // context.read<ClientTripsCubit>().resetCounter();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardCubit = context.read<ClientTripsCubit>();
      dashboardCubit.listenToUpdateOfferTripNonSocket();
    });
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

  void _loadInitialClientAcceptedTrips() {
    print("✅ loadInitialClientAcceptedTrips called");
    context.read<ClientTripsCubit>()..loadInitialClientAcceptedTrips();
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
          context.isArabic?'وضع المستخدم':'User Mode',
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
                      setState(() {
                        selectedTap='ride';
                      });
                    },
                    backColor: selectedTap=='ride'?AppColors.SECONDARY_COLOR:AppColors.PRIMARY_COLOR,
                  ),
                ),
                Sizer(),
                Expanded(
                  child: AppButton(
                    color: selectedTap=='shipping'?AppColors.whiteColor:AppColors.black,
                    radius: 15,
                    label: context.isArabic?'تحميله':'Shipping',
                    onPressed: () {
                      setState(() {
                        selectedTap='shipping';
                      });
                    },
                    backColor: selectedTap=='shipping'?AppColors.SECONDARY_COLOR:Color(0xFFE0E0E0),
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
              children: const [
                OfferRideOfferScreen(),
                AcceptRideOfferScreen(),
                PendingRideOfferScreen(),
                PastRideOfferScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return BlocBuilder<ClientTripsCubit, ClientTripsState>(
      builder: (context, state) {
        return Container(
          // height: 60,
          margin: EdgeInsetsDirectional.only(start: 16),
          child: TabBar(
            tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            controller: _tabController,
            isScrollable: true,
            indicator: const BoxDecoration(color: Colors.transparent),
            labelPadding: EdgeInsets.zero,
            onTap: (index) {
              if (index == 1) _loadInitialClientPendingTrips();
              if (index == 0) {
                context.read<ClientTripsCubit>().resetCounter();
                _loadInitialClientOfferTrips();
              }
              if (index == 2) _loadInitialClientAcceptedTrips();
              if (index == 3) _loadInitialClientPastTrips();
              setState(() {});
            },
            tabs: List.generate(_tabTitles.length, (index) {
              final isSelected = _tabController.index == index;
              return Tab(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 16, top: 10, bottom: 0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 200.w,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.PRIMARY_COLOR : const Color(0xFFE0E0E0),
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
                      if (index == 0 && state.newOfferCount > 0)
                        PositionedDirectional(
                          end: -5,
                          top: -10, // Keep badge within visible bounds
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "${state.newOfferCount}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }


}
