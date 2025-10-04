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
import '../../../../core/enums/base_status_enum.dart';
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
import 'my_bidders_screen.dart';
import 'search_auction_screen.dart'; // 👈 create this screen for search results


class AuctionScreen extends StatefulWidget {
  const AuctionScreen({super.key});

  @override
  State<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && !_isSearching) {
        final cubit = context.read<AuctionCubit>();
        switch (_tabController.index) {
          case 0:
            // cubit.loadInitialAvailableNonSocketAuction(context);
            break;
          case 1:
            // cubit.loadInitialExpiredNonSocketAuction();
            break;
          case 2:
            // cubit.loadInitialFavoriteNonSocketAuction();
            break;
          case 3:
            // cubit.loadInitialMyBidders();
            break;
          case 4:
            // cubit.loadInitialMyAuction();
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      final cubit = context.read<AuctionCubit>();

      if (_isSearching) {
        // 👉 clear old results when opening search
        cubit.searchAuctionData.clear();
        cubit.currentSearchQuery = '';
      } else {
        _searchController.clear();
        cubit.currentSearchQuery = '';
        // reload current tab
        switch (_tabController.index) {
          case 0:
            // cubit.loadInitialAvailableNonSocketAuction(context);
            break;
          case 1:
            // cubit.loadInitialExpiredNonSocketAuction();
            break;
          case 2:
            // cubit.loadInitialFavoriteNonSocketAuction();
            break;
          case 3:
            // cubit.loadInitialMyBidders();
            break;
          case 4:
            // cubit.loadInitialMyAuction();
            break;
        }
      }
    });
  }

  void _toggleSearch1() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        // Return to current tab data
        final cubit = context.read<AuctionCubit>();
        cubit.currentSearchQuery = '';
        switch (_tabController.index) {
          case 0:
            cubit.loadInitialAvailableNonSocketAuction(context);
            break;
          case 1:
            cubit.loadInitialExpiredNonSocketAuction();
            break;
          case 2:
            cubit.loadInitialFavoriteNonSocketAuction();
            break;
          case 3:
            cubit.loadInitialMyBidders();
            break;
          case 4:
            cubit.loadInitialMyAuction();
            break;
        }
      }
    });
  }

  Widget _buildBannerWidget(AuctionState state, BuildContext context) {
    if (state.auctionBanner?.data != null &&
        state.auctionBanner!.data!.isNotEmpty) {
      return Image.network(
        state.auctionBanner!.data!,
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported,
                    color: Colors.grey.shade600, size: 30),
                const SizedBox(height: 4),
                Text(
                  "Image not available",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          );
        },
      );
    }

    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, color: Colors.grey.shade600, size: 30),
          const SizedBox(height: 4),
          Text(
            "No banner available",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<AuctionCubit, AuctionState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.only(
                    top: 40, left: 16, right: 16, bottom: 16),
                color: context.isDarkMode ? Colors.black : Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: const Icon(Icons.arrow_back_ios, size: 20),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Auction",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Text(
                          "(${state.auctionWinnerData?.winnersCount ?? 0}/${state.auctionWinnerData?.allAuctionCount ?? 0}) Winners",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.emoji_events,
                            color: Colors.amber, size: 20),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (state.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _buildBannerWidget(state, context),
                      ),
                  ],
                ),
              );
            },
          ),

          // Search Bar or Tab Bar
          Container(
            color: context.isDarkMode ? Colors.black : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _isSearching
                ? TextFormField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: LocaleKeys.search.localize,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _toggleSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
              ),
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  context
                      .read<AuctionCubit>()
                      .loadInitialSearchAuction(context, value);
                }
              },
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: _toggleSearch,
                      child: SvgPicture.asset(
                        Assets.searchIcon,
                        color: context.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
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
                                final cubit =
                                context.read<AuctionCubit>();
                                switch (index) {
                                  case 0:
                                    cubit.loadInitialAvailableNonSocketAuction(
                                        context);
                                    break;
                                  case 1:
                                    cubit.loadInitialExpiredNonSocketAuction();
                                    break;
                                  case 2:
                                    cubit.loadInitialFavoriteNonSocketAuction();
                                    break;
                                  case 3:
                                    cubit.loadInitialMyBidders();
                                    break;
                                }
                              },
                              child: AnimatedBuilder(
                                animation: _tabController,
                                builder: (context, _) {
                                  final isSelected =
                                      _tabController.index == index;
                                  return Container(
                                    margin:
                                    const EdgeInsets.only(right: 4),
                                    height: 32,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? (context.isDarkMode
                                          ? AppColors
                                          .PRIMARY_COLOR_DARK
                                          : AppColors.PRIMARY_COLOR)
                                          : Colors.grey[200],
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      textAlign: TextAlign.center,
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
                Row(
                  children: [
                    const SizedBox(width: 28),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (4 < _tabController.length) {
                            _tabController.animateTo(4);
                            final cubit = context.read<AuctionCubit>();
                            cubit.loadInitialMyAuction();
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
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
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

          // Content Area
          Expanded(
            child: _isSearching
                ? const SearchAuctionScreen()
                : TabBarView(
              controller: _tabController,
              children:  [
                AvailableAuctionScreen(),
                ExpiredAuctionScreen(),
                FavoriteAuctionScreen(),
                MyBiddersScreen(),
                MyAuctionScreen(),
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
    _tabController =
        TabController(length: 5, vsync: this); // Changed to 5 tabs total

    // fetch for first tab initially
    // context.read<AuctionCubit>().getAvailableNonSocketAuction(context);

    // listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        // Only trigger when the tab change is complete, not during animation
        final cubit = context.read<AuctionCubit>();

        switch (_tabController.index) {
          case 0:
            cubit.getAvailableNonSocketAuction(context);
            break;
          case 1:
            cubit.getExpiredNonSocketAuction(); // implement in cubit
            break;
          case 2:
            // cubit.getFavoriteAuctions(); // implement in cubit
            break;
          case 3:
            cubit.getMyBidders(); // implement in cubit
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

  Widget _buildBannerWidget(AuctionState state, BuildContext context) {
    // Show loading while fetching data from API

    // Show error state with retry option
    // if (state.status == StateStatus.error) {
    //   return Container(
    //     height: 100,
    //     width: double.infinity,
    //     decoration: BoxDecoration(
    //       color: Colors.grey.shade200,
    //       borderRadius: BorderRadius.circular(12),
    //     ),
    //     alignment: Alignment.center,
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(Icons.error_outline, color: Colors.grey.shade600),
    //         const SizedBox(height: 4),
    //         Text(
    //           "Failed to load banner",
    //           style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    // Show network image with loading and error handling
    if (state.auctionBanner?.data != null &&
        state.auctionBanner!.data!.isNotEmpty) {
      return Image.network(
        state.auctionBanner!.data!,
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
        // Loading indicator while image is being downloaded
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        // Error fallback without using assets
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported,
                    color: Colors.grey.shade600, size: 30),
                const SizedBox(height: 4),
                Text(
                  "Image not available",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          );
        },
      );
    }

    // Default placeholder when no banner data
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, color: Colors.grey.shade600, size: 30),
          const SizedBox(height: 4),
          Text(
            "No banner available",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<AuctionCubit, AuctionState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.only(
                    top: 40, left: 16, right: 16, bottom: 16),
                color: context.isDarkMode ? Colors.black : Colors.white,
                child: Column(
                  children: [
                    // Row(
                    //   children:  [
                    //     GestureDetector(
                    //       onTap: (){
                    //         context.pop();
                    //       },
                    //         child: Icon(Icons.arrow_back_ios, size: 20)),
                    //     SizedBox(width: 8),
                    //     Text(LocaleKeys.auction.localize,
                    //         style: TextStyle(
                    //             fontSize: 18, fontWeight: FontWeight.w600)),
                    //     Spacer(),
                    //     Text("(22/1500) Winners",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w500, fontSize: 14)),
                    //     SizedBox(width: 6),
                    //     Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                    //   ],
                    // ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: const Icon(Icons.arrow_back_ios, size: 20),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Auction",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Text(
                          "(${state.auctionWinnerData?.winnersCount ?? 0}/${state.auctionWinnerData?.allAuctionCount ?? 0}) Winners",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 👇 Show loader while fetching
                    if (state.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _buildBannerWidget(state, context),
                      ),
                  ],
                ),
              );
            },
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
                                        .loadInitialAvailableNonSocketAuction(context);
                                    break;
                                  case 1:
                                    cubit.loadInitialExpiredNonSocketAuction();
                                    break;
                                  case 2:
                                    cubit.loadInitialFavoriteNonSocketAuction();
                                    break;
                                  case 3:
                                    cubit.loadInitialMyBidders();
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
                                      textAlign: TextAlign.center,
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
              children: [
                AvailableAuctionScreen(),
                ExpiredAuctionScreen(),
                FavoriteAuctionScreen(),
                MyBiddersScreen(),
                MyAuctionScreen(), // 5th tab content
              ],
            ),
          ),
        ],
      ),
    );
  }
}

*/