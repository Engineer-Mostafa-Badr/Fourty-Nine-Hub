import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/utils/format_numbers.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../ads_feature/ad_requests/domain/entities/requests_log_by_main_category_entity.dart';
import '../../../ads_feature/ads/presentation/widgets/marriage_call_message_buttons.dart';
import '../../../subcategories/presentation/pages/ads_request_log_card.dart';
import '../cubit/auction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'available_auction_screen.dart';
import 'expired_auction_screen.dart';
import 'favorite_auction_screen.dart';
import 'my_auction_screen.dart';

class AuctionScreen extends StatefulWidget {
  const AuctionScreen({super.key});

  @override
  State<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 5, vsync: this); // Changed to 5 tabs total

    // fetch for first tab initially
    context.read<AuctionCubit>().getAvailableNonSocketAuction();

    // listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        // Only trigger when the tab change is complete, not during animation
        final cubit = context.read<AuctionCubit>();

        switch (_tabController.index) {
          case 0:
            cubit.getAvailableNonSocketAuction();
            break;
          case 1:
            cubit.getExpiredNonSocketAuction(); // implement in cubit
            break;
          case 2:
            // cubit.getFavoriteAuctions(); // implement in cubit
            break;
          case 3:
            // cubit.getRequestLogs(); // implement in cubit
            break;
          case 4:
            cubit.getMyAuction(); // implement in cubit for My Auction tab
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== TOP CONTAINER =====
          Container(
            padding:
                const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
            color: context.isDarkMode ? Colors.black : Colors.white,
            child: Column(
              children: [
                Row(
                  children: const [
                    Icon(Icons.arrow_back_ios, size: 20),
                    SizedBox(width: 8),
                    Text("Auction",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    Spacer(),
                    Text("(22/1500) Winners",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                    SizedBox(width: 6),
                    Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    "https://picsum.photos/400/120",
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),

          // ===== CUSTOM TAB BAR CONTAINER =====
          // ===== CUSTOM TAB BAR CONTAINER =====
          Container(
            color: context.isDarkMode ? Colors.black : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First row with search icon and first 4 tabs
                Row(
                  children: [
                    SvgPicture.asset(
                      Assets.searchIcon,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        children: List.generate(4, (index) {
                          final labels = [
                            LocaleKeys.available.localize,
                            LocaleKeys.expired.localize,
                            LocaleKeys.favorite.localize,
                            LocaleKeys.myBidders.localize,
                          ];

                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (index < _tabController.length) {
                                  _tabController.animateTo(index);
                                }
                                final cubit = context.read<AuctionCubit>();
                                switch (index) {
                                  case 0:
                                    cubit
                                        .loadInitialAvailableNonSocketAuction();
                                    break;
                                  case 1:
                                    cubit.loadInitialExpiredNonSocketAuction();
                                    break;
                                  case 2:
                                    cubit.loadInitialFavoriteNonSocketAuction();
                                    break;
                                  case 3:
                                    // cubit.getRequestLogs();
                                    break;
                                  case 4:
                                    cubit.loadInitialMyAuction();
                                    break;
                                }
                              },
                              child: AnimatedBuilder(
                                animation: _tabController,
                                builder: (context, _) {
                                  final isSelected =
                                      _tabController.index == index;
                                  return Container(
                                    margin: const EdgeInsets.only(right: 4),
                                    height: 32,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? (context.isDarkMode
                                              ? AppColors.PRIMARY_COLOR_DARK
                                              : AppColors.PRIMARY_COLOR)
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      labels[index],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Second row with My Auction tab (full width)
                Row(
                  children: [
                    const SizedBox(width: 28),
                    // space to align with search icon
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (4 < _tabController.length) {
                            _tabController.animateTo(4);
                            final cubit = context.read<AuctionCubit>();
                            cubit
                                .loadInitialMyAuction(); // ✅ Force refresh like others
                          }
                        },
                        child: AnimatedBuilder(
                          animation: _tabController,
                          builder: (context, _) {
                            final isSelected = _tabController.index == 4;
                            return Container(
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (context.isDarkMode
                                        ? AppColors.PRIMARY_COLOR_DARK
                                        : AppColors.PRIMARY_COLOR)
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                LocaleKeys.myAuction.localize,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ===== TAB BAR VIEW =====
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children:  [
                AvailableAuctionScreen(),
                ExpiredAuctionScreen(),
                FavoriteAuctionScreen(),

                Center(child: Text("Request Log")),
                MyAuctionScreen(), // 5th tab content
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*
class AuctionScreen extends StatefulWidget {
  const AuctionScreen({super.key});

  @override
  State<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // fetch for first tab initially
    context.read<AuctionCubit>().getAvailableNonSocketAuction();

    // listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        // Only trigger when the tab change is complete, not during animation
        final cubit = context.read<AuctionCubit>();

        switch (_tabController.index) {
          case 0:
            cubit.getAvailableNonSocketAuction();
            break;
          case 1:
          cubit.getExpiredNonSocketAuction(); // implement in cubit
            break;
          case 2:
          // cubit.getFavoriteAuctions(); // implement in cubit
            break;
          case 3:
          // cubit.getRequestLogs(); // implement in cubit
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== TOP CONTAINER =====
          Container(
            padding:
            const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
            color: context.isDarkMode ? Colors.black : Colors.white,
            child: Column(
              children: [
                Row(
                  children: const [
                    Icon(Icons.arrow_back_ios, size: 20),
                    SizedBox(width: 8),
                    Text("Auction",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    Spacer(),
                    Text("(22/1500) Winners",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                    SizedBox(width: 6),
                    Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    "https://picsum.photos/400/120",
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),

          Row(
            // spacing: 10,
            children: [
              SizedBox(
                width: 15,
              ),
              SvgPicture.asset(
                Assets.searchIcon,
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
              Expanded(
                child: Container(
                  color: context.isDarkMode ? Colors.black : Colors.white,
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: TabBar(
                    tabAlignment: TabAlignment.start,
                    controller: _tabController,
                    isScrollable: true,
                    indicator: const BoxDecoration(color: Colors.transparent),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelPadding: EdgeInsets.zero,
                    // Remove default TabBar padding
                    onTap: (index) {
                      print("👆 TAB TAP: User tapped on tab $index");
                      // This will also trigger the listener, but it's good to have both
                      // for immediate response and consistency
                      final cubit = context.read<AuctionCubit>();
                      switch (index) {
                        case 0:
                          print("🔥 ONTAP: Calling loadInitialAvailableNonSocketAuction for tab 0");
                          cubit.loadInitialAvailableNonSocketAuction();
                          break;
                        case 1:
                          print("⚠️ ONTAP: Tab 1 (Expired) - Method commented out");
                          cubit.loadInitialExpiredNonSocketAuction();
                          break;
                        case 2:
                          print("⚠️ ONTAP: Tab 2 (Favorite) - Method commented out");
                          cubit.loadInitialFavoriteNonSocketAuction();
                          break;
                        case 3:
                          print("⚠️ ONTAP: Tab 3 (Request Log) - Method commented out");
                          // cubit.getRequestLogs();
                          break;
                      }
                    },
                    tabs: List.generate(4, (index) {
                      final labels = [
                        LocaleKeys.available.localize,
                        LocaleKeys.expired.localize,
                        LocaleKeys.favorite.localize,
                        LocaleKeys.myBidders.localize
                      ];
                      return AnimatedBuilder(
                        animation: _tabController,
                        builder: (context, _) {
                          final isSelected = _tabController.index == index;
                          return Container(
                            margin: const EdgeInsets.only(right: 4),
                            // Only 4px space between tabs
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (context.isDarkMode
                                  ? AppColors.PRIMARY_COLOR_DARK
                                  : AppColors.PRIMARY_COLOR)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              labels[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),

          // ===== BUTTON under tabs =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: AppButton(
              onPressed: () {
                context.push(Routes.myAuctionScreen);
              },
              width: double.infinity,
              backColor: AppColors.cE0E0E0,
              label: LocaleKeys.myAuction.localize,
              style: Styles.mediumText(color: AppColors.black),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                AvailableAuctionScreen(),
                ExpiredAuctionScreen(),
                FavoriteAuctionScreen(),
                // Center(child: Text("Expired Auctions")),
                // Center(child: Text("Favorite Auctions")),
                Center(child: Text("Request Log")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

*/
