import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/common/tab_widget.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/client_trips_cubit/client_trips_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_offers/past_ride_offer_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_offers/pending_ride_offer_screen.dart';
import 'package:fourtyninehub/shared_web_socket.dart';

import 'accept_ride_offer_screen.dart';
import 'offer_ride_offer_screen.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class MainTabsRideOffer extends StatefulWidget {
  const MainTabsRideOffer({super.key, this.type = 'ride'});
  final String? type;

  @override
  State<MainTabsRideOffer> createState() => _MainTabsRideOfferState();
}

class _MainTabsRideOfferState extends State<MainTabsRideOffer> with SingleTickerProviderStateMixin {
  final List<String> _tabTitles = [LocaleKeys.offers.localize, LocaleKeys.pending.localize,LocaleKeys.accepted.localize,  LocaleKeys.past.localize];

  String selectedTap = 'ride';

  @override
  void initState() {
    super.initState();
    selectedTap = widget.type ?? 'ride';
    if (widget.type == 'ride') {
      context.read<ClientTripsCubit>().loadInitialClientOfferTrips();
    }
    // if (widget.type == 'ride') {
    context.read<ClientTripsCubit>().listenToUpdateOfferTripNonSocket();
    context.read<ClientTripsCubit>().listenToUpdateOfferTripShipping();
    // }
    if (widget.type == 'shipping') {
      context.read<ClientTripsCubit>().loadInitialClientOfferShippingTrips();
    }
    context.read<ClientTripsCubit>().tabController = TabController(length: _tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    SharedWebSocket.socket!.off("LOADING:NEW_TRIP_OFFER_UPDATED");
    SharedWebSocket.socket!.off("RIDE:NON_TRACKING_OFFERS_UPDATE");
    context.read<ClientTripsCubit>().tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      enableCustomAppBar: true,
      appBar: BackAppBar(
        label: context.isArabic ? 'وضع المستخدم' : 'User Mode',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TabWidget(
                    title: LocaleKeys.ride.tr(),
                    onTap: () {
                      ManageVibration.vibrate();
                      if (selectedTap != 'ride') {
                        setState(() {
                          selectedTap = 'ride';
                        });

                        if (context.read<ClientTripsCubit>().tabController.index == 1) {
                          // if (widget.type == 'ride')
                          context.read<ClientTripsCubit>().loadInitialClientPendingTrips();
                          // if (widget.type == 'shipping') context.read<ClientTripsCubit>().loadInitialClientPendingShippingTrips();
                        }
                        if (context.read<ClientTripsCubit>().tabController.index == 2) {
                          // if (selectedTap == 'ride')
                          context.read<ClientTripsCubit>().loadInitialClientAcceptedTrips();
                          // if (selectedTap == 'shipping')context.read<ClientTripsCubit>().loadInitialClientAcceptedShippingTrips();
                        }
                        if (context.read<ClientTripsCubit>().tabController.index == 0) {
                          // if (selectedTap == 'ride')
                          context.read<ClientTripsCubit>().loadInitialClientOfferTrips();
                          // if (selectedTap == 'shipping')context.read<ClientTripsCubit>().loadInitialClientOfferShippingTrips();
                        }
                        if (context.read<ClientTripsCubit>().tabController.index == 3) {
                          print("object");
                          // if (selectedTap == 'ride')
                          context.read<ClientTripsCubit>().loadInitialClientPastTrips();
                          // if (selectedTap == 'shipping')context.read<ClientTripsCubit>().loadInitialClientPastShippingTrips();
                        }
                      }
                    },
                    selected: selectedTap == 'ride',
                  ),
                ),
                Sizer(),
                Expanded(
                  child: TabWidget(
                    selected: selectedTap == 'shipping',
                    title: context.isArabic ? 'تحميله' : 'Shipping',
                    onTap: () {
                      ManageVibration.vibrate();
                      if (selectedTap != 'shipping') {
                        setState(() {
                          selectedTap = 'shipping';
                        });
                        if (context.read<ClientTripsCubit>().tabController.index == 1) {
                          // if (selectedTap == 'ride') context.read<ClientTripsCubit>().loadInitialClientPendingTrips();
                          // if (selectedTap == 'shipping')
                          context.read<ClientTripsCubit>().loadInitialClientPendingShippingTrips();
                        }
                        if (context.read<ClientTripsCubit>().tabController.index == 2) {
                          // if (selectedTap == 'ride')context.read<ClientTripsCubit>().loadInitialClientAcceptedTrips();
                          // if (selectedTap == 'shipping')
                          context.read<ClientTripsCubit>().loadInitialClientAcceptedShippingTrips();
                        }
                        if (context.read<ClientTripsCubit>().tabController.index == 0) {
                          // if (selectedTap == 'ride')context.read<ClientTripsCubit>().loadInitialClientOfferTrips();
                          // if (selectedTap == 'shipping')
                          context.read<ClientTripsCubit>().loadInitialClientOfferShippingTrips();
                        }
                        if (context.read<ClientTripsCubit>().tabController.index == 3) {
                          print("object");
                          // if (selectedTap == 'ride')context.read<ClientTripsCubit>().loadInitialClientPastTrips();
                          // if (selectedTap == 'shipping')
                          context.read<ClientTripsCubit>().loadInitialClientPastShippingTrips();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Sizer(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: context.read<ClientTripsCubit>().tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                OfferRideOfferScreen(
                  type: selectedTap,
                ),
                PendingRideOfferScreen(
                  type: selectedTap,
                ),
                AcceptRideOfferScreen(
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
      margin: const EdgeInsetsDirectional.only(start: 16),
      child: TabBar(
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        controller: context.read<ClientTripsCubit>().tabController,
        isScrollable: true,
        indicator: const BoxDecoration(color: Colors.transparent),
        labelPadding: EdgeInsets.zero,
        onTap: (index) {

        },
        tabs: List.generate(_tabTitles.length, (index) {
          final isSelected = context.read<ClientTripsCubit>().tabController.index == index;
          return Padding(
            padding: EdgeInsetsDirectional.only(end: 12.w),
            child: Tab(
              child: SizedBox(
                width: 180.w,
                child: TabWidget(
                  title: _tabTitles[index],
                  selected: isSelected,
                  onTap: () {
                    context.read<ClientTripsCubit>().tabController.animateTo(index);
                    if (index == 0) {
                      if (selectedTap == 'ride') {
                        context.read<ClientTripsCubit>().loadInitialClientOfferTrips();
                      } else {
                        context.read<ClientTripsCubit>().loadInitialClientOfferShippingTrips();
                      }
                    } else if (index == 1) {
                      if (selectedTap == 'ride') {
                        context.read<ClientTripsCubit>().loadInitialClientPendingTrips();
                      } else {
                        context.read<ClientTripsCubit>().loadInitialClientPendingShippingTrips();
                      }
                    } else if (index == 2) {
                      if (selectedTap == 'ride') {
                        context.read<ClientTripsCubit>().loadInitialClientAcceptedTrips();
                      } else {
                        context.read<ClientTripsCubit>().loadInitialClientAcceptedShippingTrips();
                      }
                    } else if (index == 3) {
                      if (selectedTap == 'ride') {
                        context.read<ClientTripsCubit>().loadInitialClientPastTrips();
                      } else {
                        context.read<ClientTripsCubit>().loadInitialClientPastShippingTrips();
                      }
                    }
                    setState(() {});
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

}
