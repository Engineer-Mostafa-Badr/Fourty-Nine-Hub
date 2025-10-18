import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/common/default_app_bar.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/winner_overlay_widget.dart';
import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../core/widget/common/tab_widget.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../domain/entities/listen_winner_bid_entity.dart';
import '../cubit/auction_cubit.dart';
import 'available_auction_screen.dart';
import 'expired_auction_screen.dart';
import 'favorite_auction_screen.dart';
import 'fetch_single_auction_screen.dart';
import 'my_auction_screen.dart';
import 'my_bidders_screen.dart';
import 'search_auction_screen.dart';

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
    final cubit = context.read<AuctionCubit>();

    Future.microtask(() {
      cubit.listenToBidWinner(); // ✅ listen globally for winner updates
    });
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
    // context.read<AuctionCubit>().disposeSocketListeners(); // ✅ clean up listeners
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


  Widget _buildBannerWidget(AuctionState state, BuildContext context) {
    if (state.auctionBanner?.data != null &&
        state.auctionBanner!.data!.isNotEmpty) {
      return Image.network(
        state.auctionBanner!.data!,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              // borderRadius: BorderRadius.circular(12),
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
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              // borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported, color: Colors.white, size: 30),
                const SizedBox(height: 4),
                Text(
                  "Image not available",
                  style: TextStyle(color: Colors.white, fontSize: 12),
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // for Android
      statusBarBrightness: Brightness.dark, // for iOS
    ));
    return BlocListener<AuctionCubit, AuctionState>(
      listenWhen: (previous, current) =>
      previous.bidWinner != current.bidWinner && current.bidWinner != null,
      listener: (context, state) {
        final winner = state.bidWinner;
        if (winner != null) {
          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: 'WinnerOverlay',
            barrierColor: Colors.black54, // optional: slight background dim
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (context, _, __) {
              return WinnerOverlay(
                winner: winner,
                onClose: () {
                  Navigator.of(context).pop(); // close overlay
                },
              );
            },
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              // optional: fade + scale animation
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween(begin: 0.95, end: 1.0).animate(animation),
                  child: child,
                ),
              );
            },
          );
        }
      },
  child: BlocBuilder<AuctionCubit, AuctionState>(
    builder: (context,state) {
      return Scaffold(
          // scaffoldBackgroundWithAppBarColor: AppColors.PRIMARY_COLOR,
          // backgroundColor: AppColors.PRIMARY_COLOR,
          // enableCustomAppBar: true,
          appBar: DefaultAppBar(
            title:LocaleKeys.auction.localize,
            actions: [
              const SizedBox(width: 6),
              // const Spacer(),
              Text(
                "(${state.auctionWinnerData?.winnersCount ?? 0}/${state.auctionWinnerData?.allAuctionCount ?? 0}) ${LocaleKeys.winners.localize}",
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.white),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
              const SizedBox(width: 5),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AuctionCubit, AuctionState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      if (state.isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else
                        ClipRRect(
                          // borderRadius: BorderRadius.circular(12),
                          child: _buildBannerWidget(state, context),
                        ),
                    ],
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
                            color: context.isDarkMode ? Colors.white : Colors.black,
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

                              // final counts = [
                              //   // context.watch<AuctionCubit>().state.availableCount ?? 0,
                              //   // context.watch<AuctionCubit>().state.expiredCount ?? 0,
                              //   // context.watch<AuctionCubit>().state.favoriteCount ?? 0,
                              //   // context.watch<AuctionCubit>().state.myBiddersCount ?? 0,
                              // ];

                              return Expanded(
                                child: AnimatedBuilder(
                                  animation: _tabController,
                                  builder: (context, _) {
                                    final isSelected = _tabController.index == index;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: TabWidget(
                                        title: labels[index],
                                        // count: counts[index],
                                        selected: isSelected,
                                        onTap: () {
                                          _tabController.animateTo(index);
                                          final cubit = context.read<AuctionCubit>();
                                          switch (index) {
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
                                          }
                                        },
                                      ),
                                    );
                                  },
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
                          child: AnimatedBuilder(
                            animation: _tabController,
                            builder: (context, _) {
                              final isSelected = _tabController.index == 4;
                              return TabWidget(
                                title: LocaleKeys.myAuction.localize,
                                // count: context.watch<AuctionCubit>().state.myAuctionCount ?? 0,
                                selected: isSelected,
                                onTap: () {
                                  _tabController.animateTo(4);
                                  final cubit = context.read<AuctionCubit>();
                                  cubit.loadInitialMyAuction();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )

              ),

              // Content Area
              Expanded(
                child: _isSearching
                    ? const SearchAuctionScreen()
                    : TabBarView(
                        controller: _tabController,
                        children: [
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
  ),
);
  }
}



