// chance_main_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/star_feature/presentation/tube_feed/widgets/cards/sticky_tab_bar_delegate.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../service_locator/service_locator.dart';

import 'chance_winners_view.dart';
import '../controller/cubit/chance_cubit.dart';
import '../controller/cubit/chance_states.dart';
import '../../../../core/utils/arabic_pluralization.dart';
import '../../../../core/utils/format_numbers.dart';
import '../../domain/entity/chance_ad_entity.dart';
import '../../domain/use_case/join_chance_ad_use_case.dart';

import '../widgets/floating_action_button_widget.dart';
import 'chance_detail_view.dart';
import '../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../core/widget/olx_pagination/banner.dart';

enum ChanceStatus { available, winner, ended }

// Main View
class ChanceMainView extends StatelessWidget {
  const ChanceMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ChanceCubit>()..getAllChanceAds(),
      child: Builder(
        builder: (context) => const _ChanceMainViewBody(),
      ),
    );
  }
}

class _ChanceMainViewBody extends StatefulWidget {
  const _ChanceMainViewBody();

  @override
  State<_ChanceMainViewBody> createState() => _ChanceMainViewState();
}

class _ChanceMainViewState extends State<_ChanceMainViewBody>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearching = false;
  bool _isCategoriesVisible = false;
  final TextEditingController _searchController = TextEditingController();
  // Removed _paginationScrollController since we're using slivers now
  int _selectedTabIndex = 0;

  // Main scroll controller for the outer NestedScrollView
  final ScrollController _mainScrollController = ScrollController();

  // Individual controllers for each tab content
  final ScrollController _availableController = ScrollController();
  final ScrollController _favoriteController = ScrollController();
  final ScrollController _expireController = ScrollController();
  final ScrollController _myChanceController = ScrollController();

  bool _isSyncing = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _searchController.addListener(_onSearchChanged);

    // Setup scroll synchronization
    _setupScrollSynchronization();

    // Load winner statistics
    context.read<ChanceCubit>().getWinnerStatistics();
  }

  void _setupScrollSynchronization() {
    // Sync main controller with active tab controller
    _mainScrollController.addListener(() => _syncFromMain());

    // Sync tab controllers with main controller
    _availableController.addListener(() => _syncToMain(_availableController));
    _favoriteController.addListener(() => _syncToMain(_favoriteController));
    _expireController.addListener(() => _syncToMain(_expireController));
    _myChanceController.addListener(() => _syncToMain(_myChanceController));
  }

  void _syncFromMain() {
    if (_isSyncing || !mounted) return;
    _isSyncing = true;

    final activeController = _getActiveTabController();
    if (activeController != null &&
        activeController.hasClients &&
        _mainScrollController.hasClients &&
        mounted) {
      activeController.jumpTo(_mainScrollController.offset.clamp(
        activeController.position.minScrollExtent,
        activeController.position.maxScrollExtent,
      ));
    }
    _isSyncing = false;
  }

  void _syncToMain(ScrollController tabController) {
    if (_isSyncing || !mounted) return;
    if (tabController != _getActiveTabController()) return;
    _isSyncing = true;

    if (_mainScrollController.hasClients &&
        tabController.hasClients &&
        mounted) {
      _mainScrollController.jumpTo(tabController.offset.clamp(
        _mainScrollController.position.minScrollExtent,
        _mainScrollController.position.maxScrollExtent,
      ));
    }
    _isSyncing = false;
  }

  ScrollController? _getActiveTabController() {
    try {
      switch (_selectedTabIndex) {
        case 0:
          return _availableController.hasClients ? _availableController : null;
        case 1:
          return _favoriteController.hasClients ? _favoriteController : null;
        case 2:
          return _expireController.hasClients ? _expireController : null;
        case 3:
          return _myChanceController.hasClients ? _myChanceController : null;
        default:
          return null;
      }
    } catch (e) {
      debugPrint('Error getting active tab controller: $e');
      return null;
    }
  }

  void _onTabChanged() {
    setState(() {
      _selectedTabIndex = _tabController.index;
      // Clear search when switching tabs
      _isSearching = false;
      _isCategoriesVisible = false;
      _searchController.clear();
    });

    // Load data based on selected tab
    switch (_selectedTabIndex) {
      case 1: // Favorite
        context.read<ChanceCubit>().getFavoriteChanceAds();
        break;
      case 2: // Expire
        context.read<ChanceCubit>().getExpiredChanceAds();
        break;
      case 3: // My Talent
        context.read<ChanceCubit>().getMyChanceAds();
        break;
      default:
        // Available tab - data already loaded
        break;
    }
  }

  void _onSearchChanged() {
    setState(() {
      _isCategoriesVisible = _searchController.text.isNotEmpty;
    });

    if (_searchController.text.isNotEmpty) {
      context.read<ChanceCubit>().searchChanceAds(_searchController.text);
    } else {
      context.read<ChanceCubit>().getAllChanceAds();
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _isCategoriesVisible = false;
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChanceCubit, ChanceState>(
      listener: (context, state) {
        if (state.status == ChanceStates.joinSuccess) {
          showSuccessMessage(
              context,
              context.isArabic
                  ? 'تم الانضمام للفرصة بنجاح'
                  : 'Joined chance successfully');
          _refreshChanceAds();
        } else if (state.status == ChanceStates.error) {
          showErrorMessage(context, getFailureMessage(state.failure!, context));
        }
      },
      child: BlocBuilder<ChanceCubit, ChanceState>(
        builder: (context, state) {
          return CustomScaffold(
            enableCustomAppBar: true,
            backgroundColor: Colors.grey[50],
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(30),
              child: BackAppBar(
                labelSize: 32,
                enableCustomAppBar: true,
                label: context.isArabic ? 'فرصة' : 'Chance',
                backColor: context.isDarkMode
                    ? AppColors.Floating_Button_COLOR_DARK
                    : AppColors.PRIMARY_COLOR,
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: GestureDetector(
                      onTap: () {
                        ManageVibration.vibrate();
                        final chanceCubit = context.read<ChanceCubit>();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: chanceCubit,
                              child: const ChanceWinnersView(),
                            ),
                          ),
                        );
                      },
                      child: BlocBuilder<ChanceCubit, ChanceState>(
                        builder: (context, state) {
                          int totalWinners = 0;
                          int totalAds = 0;

                          if (state.winnerStatistics != null) {
                            totalWinners = state.winnerStatistics!.totalWinner;
                            totalAds = state.winnerStatistics!.totalAds;
                          }

                          final winnerText = ArabicPluralization.getWinnerText(
                            totalWinners,
                            context.isArabic,
                          );

                          final formatNumbers = FormatNumbers();
                          final displayTotalWinners = context.isArabic
                              ? formatNumbers.convertToArabicNumerals(
                                  totalWinners.toString())
                              : totalWinners.toString();
                          final displayTotalAds = context.isArabic
                              ? formatNumbers
                                  .convertToArabicNumerals(totalAds.toString())
                              : totalAds.toString();

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$winnerText ($displayTotalWinners/$displayTotalAds)',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  color: !context.isDarkMode
                                      ? Colors.white
                                      : AppColors.PRIMARY_COLOR,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Image.asset(
                                Assets.cupImage,
                                // width: 22,
                                // height: 22,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: NestedScrollView(
              controller: _mainScrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  // Banner - يختفي مع الـ scroll
                  if (!_isSearching)
                    SliverAppBar(
                      pinned: false,
                      floating: false,
                      snap: false,
                      expandedHeight: 200.h,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      surfaceTintColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: _buildBanner(),
                        collapseMode: CollapseMode.parallax,
                      ),
                    ),

                  // Sticky Tabs - Normal state
                  if (!_isSearching)
                    SliverPersistentHeader(
                      pinned: true,
                      floating: false,
                      delegate: StickyTabBarDelegate(
                        tabController: _tabController,
                        context: context,
                        onSearchTap: _toggleSearch,
                        showSearchField: false,
                        tabTitles: [
                          context.isArabic ? 'متاح' : 'Available',
                          context.isArabic ? 'مفضلة' : 'Favorite',
                          context.isArabic ? 'منتهي' : 'Expire',
                          context.isArabic ? 'فرصي' : 'My Chance',
                        ],
                      ),
                    ),

                  // Sticky Tabs - Search state
                  if (_isSearching)
                    SliverPersistentHeader(
                      pinned: true,
                      floating: false,
                      delegate: StickyTabBarDelegate(
                        tabController: _tabController,
                        context: context,
                        onSearchTap: _toggleSearch,
                        showSearchField: true,
                        searchController: _searchController,
                        tabTitles: [
                          context.isArabic ? 'متاح' : 'Available',
                          context.isArabic ? 'مفضلة' : 'Favorite',
                          context.isArabic ? 'منتهي' : 'Expire',
                          context.isArabic ? 'فرصي' : 'My Chance',
                        ],
                        // onSearchChanged: _onSearchChanged,
                      ),
                    ),

                  // Categories Section (if visible during search) - نقلتها لتحت الـ tabs
                  if (_isCategoriesVisible && _isSearching)
                    SliverToBoxAdapter(
                      child: _buildCategoriesSection(),
                    ),
                ];
              },
              body: _buildSynchronizedTabContent(state),
            ),
            floatingActionButton: FloatingActionButtonWidget(),
          );
        },
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800&h=400&fit=crop',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      'Cars',
      'Real Estate',
      'Electronics',
      'Home Appliances',
      'Furniture',
      'Fashion & Clothing',
      'Watches & Accessories',
      'Sports Equipment',
      'Books & Stationery',
      'Pets & Pet Supplies',
      'Health & Beauty Products',
      'Toys & Kids Items',
      'Tools & Hardware'
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: categories.map((category) {
          return ListTile(
            title: Text(
              category,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              ManageVibration.vibrate();
              setState(() {
                _isCategoriesVisible = false;
                _isSearching = false;
                _searchController.clear();
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSynchronizedTabContent(ChanceState state) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        _buildTabContentSliver(state),
      ],
    );
  }

  Widget _buildTabContentSliver(ChanceState state) {
    if (state.isLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.isFailure) {
      return const SliverFillRemaining(
        child: Center(
          child: Text(
            'خطأ في تحميل البيانات',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      );
    }

    // Return content based on selected tab index (controlled by StickyTabBarDelegate)
    switch (_selectedTabIndex) {
      case 0: // Available
        return _buildAvailableTabSliver(state);
      case 1: // Favorite
        return _buildFavoriteTabSliver(state);
      case 2: // Expire
        return _buildExpireTabSliver(state);
      case 3: // My Talent
        return _buildMyTalentTabSliver(state);
      default:
        return _buildAvailableTabSliver(state);
    }
  }

  Widget _buildAvailableTabSliver(ChanceState state) {
    final List<ChanceAdEntity> ads =
        _isSearching && _searchController.text.isNotEmpty
            ? (state.searchResults ?? [])
            : (state.chanceAds ?? []);

    if (ads.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            context.isArabic ? 'لا توجد إعلانات متاحة' : 'No available ads',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return SliverFillRemaining(
      hasScrollBody: false,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .7,
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: AppColors.PRIMARY_COLOR_DARK,
          child: OlxPaginationWidget(
            items: ads.map((ad) => _buildChanceCardFromEntity(ad)).toList(),
            banners: bannersList,
            loadPage: _loadChanceAdsPage,
            scrollController:
                _availableController, // Let it handle its own scrolling
            itemsPerPage: 5,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteTabSliver(ChanceState state) {
    final List<ChanceAdEntity> favoriteAds = state.favoriteChanceAds ?? [];

    if (favoriteAds.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Text(
            'لا توجد إعلانات مفضلة',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: AppColors.PRIMARY_COLOR_DARK,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: favoriteAds.length,
          itemBuilder: (context, index) {
            final ad = favoriteAds[index];
            return _buildChanceCardFromEntity(ad, isFavorite: true);
          },
        ),
      ),
    );
  }

  Widget _buildExpireTabSliver(ChanceState state) {
    final List<ChanceAdEntity> expiredAds = state.expiredChanceAds ?? [];

    if (expiredAds.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Text(
            'لا توجد إعلانات منتهية',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: AppColors.PRIMARY_COLOR_DARK,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: expiredAds.length,
          itemBuilder: (context, index) {
            final ad = expiredAds[index];
            return _buildExpiredChanceCard(ad);
          },
        ),
      ),
    );
  }

  Widget _buildMyTalentTabSliver(ChanceState state) {
    final List<ChanceAdEntity> myAds = state.myChanceAds ?? [];

    if (myAds.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Text(
            'لا توجد إعلانات خاصة بك',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: AppColors.PRIMARY_COLOR_DARK,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: myAds.length,
          itemBuilder: (context, index) {
            final ad = myAds[index];
            return _buildChanceCardFromEntity(ad, isMyChance: true);
          },
        ),
      ),
    );
  }

  Widget _buildChanceCardFromEntity(
    ChanceAdEntity ad, {
    bool isFavorite = false,
    bool isMyChance = false,
  }) {
    final List<String> imageUrls = ad.images.map((img) => img.photo).toList();
    final double progress = ad.totalContributions / ad.price;
    final ChanceStatus status = ad.isComplete
        ? (ad.winnerId != null ? ChanceStatus.winner : ChanceStatus.ended)
        : ChanceStatus.available;

    return _buildChanceCard(
      title: ad.title,
      price: ad.price.toInt(),
      endDate: ad.isComplete ? 'Ended' : 'Active',
      progress: progress.clamp(0.0, 1.0),
      participants: ad.contributorsCount ?? ad.contributors,
      views: ad.views,
      images: imageUrls.isNotEmpty
          ? imageUrls
          : ['https://via.placeholder.com/400x300'],
      status: status,
      isFavorite: ad.isFavorite, // Use actual favorite status from entity
      isMyChance: isMyChance,
      description: ad.description,
      adId: ad.id,
      chanceAd: ad,
    );
  }

  Widget _buildExpiredChanceCard(ChanceAdEntity ad) {
    final List<String> imageUrls = ad.images.map((img) => img.photo).toList();
    final double progress = ad.totalContributions / ad.price;
    final ChanceStatus status =
        ad.winnerId != null ? ChanceStatus.winner : ChanceStatus.ended;

    // Extract winner name if winnerId is an object
    String? winnerName;
    if (ad.winnerId != null && ad.winnerId is Map<String, dynamic>) {
      final winnerData = ad.winnerId as Map<String, dynamic>;
      final userData = winnerData['userId'] as Map<String, dynamic>?;
      if (userData != null) {
        winnerName =
            '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'
                .trim();
      }
    }

    return _buildChanceCard(
      title: ad.title,
      price: ad.price.toInt(),
      endDate: 'Ended',
      progress: progress.clamp(0.0, 1.0),
      participants: ad.contributors,
      views: ad.views,
      images: imageUrls.isNotEmpty
          ? imageUrls
          : ['https://via.placeholder.com/400x300'],
      status: status,
      isFavorite: ad.isFavorite,
      isMyChance: false,
      adId: ad.id,
      chanceAd: ad,
      description: ad.description,
      winnerName:
          winnerName ?? (ad.winnerId != null ? 'Winner Selected' : null),
    );
  }

  Widget _buildChanceCard({
    required String title,
    required int price,
    required String endDate,
    required double progress,
    required int participants,
    required int views,
    required String description,
    required List<String> images,
    required ChanceStatus status,
    String? winnerName,
    bool isFavorite = false,
    bool isMyChance = false,
    String? adId,
    ChanceAdEntity? chanceAd,
  }) {
    return GestureDetector(
      onTap: () async {
        ManageVibration.vibrate();
        // Navigate to chance ad details
        if (adId != null) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => serviceLocator<ChanceCubit>(),
                // child: ChanceAdDetailsView(chanceAdId: adId),
                child: ChanceDetailView(
                  title: title,
                  price: price,
                  images: images,
                  progress: progress,
                  participants: participants,
                  views: views,
                  description: description,
                  chanceAd: chanceAd,
                ),
              ),
            ),
          );

          // Refresh data when returning from detail view
          _refreshChanceAds();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                Container(
                  height: 250.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(24.r)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 250.h,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                        autoPlay: true,
                      ),
                      items: images.map((image) {
                        return Image.network(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                // Favorite Icon
                Positioned(
                  top: 20.h,
                  left: 20.w,
                  child: BlocBuilder<ChanceCubit, ChanceState>(
                    builder: (context, state) {
                      // Get updated favorite status from state
                      bool currentFavoriteStatus = isFavorite;

                      // في تبويب المفضلة، القلب دائماً أحمر
                      if (isFavorite) {
                        currentFavoriteStatus = true;
                      } else if (adId != null) {
                        try {
                          ChanceAdEntity? updatedAd;

                          // Search in all lists
                          if (state.chanceAds != null) {
                            try {
                              updatedAd = state.chanceAds!
                                  .firstWhere((ad) => ad.id == adId);
                            } catch (e) {
                              // Continue searching in other lists
                            }
                          }

                          if (updatedAd == null &&
                              state.favoriteChanceAds != null) {
                            try {
                              updatedAd = state.favoriteChanceAds!
                                  .firstWhere((ad) => ad.id == adId);
                            } catch (e) {
                              // Continue searching in other lists
                            }
                          }

                          if (updatedAd == null &&
                              state.expiredChanceAds != null) {
                            try {
                              updatedAd = state.expiredChanceAds!
                                  .firstWhere((ad) => ad.id == adId);
                            } catch (e) {
                              // Continue searching in other lists
                            }
                          }

                          if (updatedAd == null && state.myChanceAds != null) {
                            try {
                              updatedAd = state.myChanceAds!
                                  .firstWhere((ad) => ad.id == adId);
                            } catch (e) {
                              // Ad not found anywhere
                            }
                          }

                          if (updatedAd != null) {
                            currentFavoriteStatus = updatedAd.isFavorite;
                          }
                        } catch (e) {
                          // Keep original favorite status
                          currentFavoriteStatus = isFavorite;
                        }
                      }

                      return GestureDetector(
                        onTap: () {
                          ManageVibration.vibrate();
                          if (adId != null && adId.isNotEmpty) {
                            print('Toggling favorite for adId: $adId');
                            context
                                .read<ChanceCubit>()
                                .toggleChanceAdFavorite(adId);
                          } else {
                            print('Error: adId is null or empty');
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            currentFavoriteStatus
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: currentFavoriteStatus
                                ? Colors.red
                                : Colors.grey,
                            size: 30.sp,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Carousel Indicators
                // if (images.length > 1)
                //   Positioned(
                //     bottom: 12.h,
                //     left: 0,
                //     right: 0,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: images.map((image) {
                //         int index = images.indexOf(image);
                //         return Container(
                //           width: 6.w,
                //           height: 6.h,
                //           margin: EdgeInsets.symmetric(horizontal: 2.w),
                //           decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             color: index == 0
                //                 ? Colors.white
                //                 : Colors.white.withOpacity(0.5),
                //           ),
                //         );
                //       }).toList(),
                //     ),
                //   ),
              ],
            ),
            // Content Section
            Padding(
              padding: EdgeInsets.all(28.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff0D141C),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // // description
                  // Text(
                  //   description,
                  // style: TextStyle(
                  //   fontSize: 24.sp,
                  //   fontWeight: FontWeight.w400,
                  //   color: Color(0xff0B1035),
                  // ),
                  // ),
                  // SizedBox(height: 8.h),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.isArabic
                            ? FormatNumbers()
                                .convertToArabicNumerals(price.toString())
                            : price.toString(),
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff0B1035),
                        ),
                      ),
                      Sizer(width: 8.w),
                      Text(
                        context.isArabic ? 'جنيه مصري' : 'EGP',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff0B1035),
                        ),
                      ),
                      Spacer(),
                      Text(
                        endDate,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w400,
                          color: status == ChanceStatus.available
                              ? Colors.orange
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Progress Bar
                  Text(
                    '${context.isArabic ? FormatNumbers().convertToArabicNumerals((progress * 100).toInt().toString()) : (progress * 100).toInt().toString()}% ${context.isArabic ? 'مكتمل' : 'Completed'}',
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Color(0xff0D141C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      !chanceAd!.isComplete
                          ? AppColors.c0B1035
                          : Color(0xff1EAA61),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Stats and Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${context.isArabic ? FormatNumbers().convertToArabicNumerals(participants.toString()) : participants.toString()} ${context.isArabic ? 'مشارك' : 'Participant'}',
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.cF33D49,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            Assets.eyeChance,
                            width: 20.w,
                            height: 20.h,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '${context.isArabic ? FormatNumbers().convertToArabicNumerals(_formatViews(views)) : _formatViews(views)} ${context.isArabic ? 'مشاهدة' : 'Views'}',
                            style: TextStyle(
                              fontSize: 32.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      // Action Button
                      GestureDetector(
                        onTap: () {
                          ManageVibration.vibrate();
                          if (status == ChanceStatus.winner) {
                            _showWinnerDialogFromAd(chanceAd);
                          } else if (adId != null) {
                            final cubit = context.read<ChanceCubit>();
                            _showJoinDialog(chanceAd, cubit);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: status == ChanceStatus.winner
                                ? Colors.orange
                                : Colors.red,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            status == ChanceStatus.winner
                                ? context.isArabic
                                    ? 'الفائز'
                                    : 'Winner'
                                : context.isArabic
                                    ? 'انضم الآن'
                                    : 'Join Now',
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWinnerDialogFromAd(ChanceAdEntity ad) {
    String winnerName = 'Winner';
    String? profilePicture;
    String amount = '0';

    if (ad.winnerId != null && ad.winnerId is Map<String, dynamic>) {
      final winnerData = ad.winnerId as Map<String, dynamic>;
      final userData = winnerData['userId'] as Map<String, dynamic>?;

      if (userData != null) {
        winnerName =
            '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'
                .trim();

        // Get profile picture
        final userProfile = userData['USER_PROFILE'] as Map<String, dynamic>?;
        if (userProfile != null) {
          final profilePictureKey =
              userProfile['profilePictureKey'] as Map<String, dynamic>?;
          if (profilePictureKey != null) {
            profilePicture = profilePictureKey['mediaKey'] as String?;
          }
        }
      }

      // Get amount
      if (winnerData['amount'] != null) {
        amount = winnerData['amount'].toString();
      }
    }

    _showWinnerDialog(winnerName, profilePicture, amount);
  }

  void _showWinnerDialogWithData(String adId) async {
    // Show loading first
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Get winner data
    final cubit = context.read<ChanceCubit>();
    final winnerData = await cubit.getWinnerData(adId);

    // Close loading dialog
    Navigator.pop(context);

    if (winnerData != null) {
      _showWinnerDialog(
        winnerData['name'] ?? 'Unknown',
        winnerData['profilePicture'],
        winnerData['amount']?.toString() ?? '0',
      );
    } else {
      _showWinnerDialog('Winner', null, '0');
    }
  }

  void _showWinnerDialog(String winnerName,
      [String? profilePicture, String? amount]) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              width: double.infinity,
              height: 150.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                color: Colors.white.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x40000000),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Winner avatar with crown
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ImageFromInternet(
                              width: 120.w,
                              height: 120.h,
                              image: profilePicture ??
                                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
                              isCircle: true,
                              firstChar: winnerName[0].toUpperCase(),
                              charPadding: 3,
                            ),
                            Positioned(
                              top: -25.h,
                              right: -2.w,
                              child: SvgPicture.asset(
                                context.isDarkMode
                                    ? Assets.crownIconDark
                                    : Assets.crownIcon,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20.w),
                        // Winner details
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              winnerName,
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              '21/3/2024',
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              '${amount ?? '10000'} EGP',
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              'iPhone 16',
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Close button positioned at top right
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: GestureDetector(
                      onTap: () {
                        ManageVibration.vibrate();

                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 30.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    } else {
      return views.toString();
    }
  }

  void _refreshChanceAds() {
    // Refresh data based on current tab
    final cubit = context.read<ChanceCubit>();

    switch (_tabController.index) {
      case 0: // All Ads
        cubit.getAllChanceAds();
        break;
      case 1: // Favorites
        cubit.getFavoriteChanceAds();
        break;
      case 2: // Expire
        cubit.getExpiredChanceAds();
        break;
      case 3: // My Ads
        cubit.getMyChanceAds();
        break;
      default:
        cubit.getAllChanceAds();
    }
  }

  Future<void> _loadChanceAdsPage(int page) async {
    final cubit = context.read<ChanceCubit>();
    await cubit.getAllChanceAds(page: page, limit: 10);
  }

  // void _showJoinDialog(ChanceAdEntity chanceAd) {
  //   final TextEditingController amountController = TextEditingController();
  //   final cubit = context.read<ChanceCubit>();

  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     isScrollControlled: true,
  //     builder: (dialogContext) => BlocProvider.value(
  //       value: cubit,
  //       child: Container(
  //         padding: EdgeInsets.only(
  //           bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
  //         ),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
  //         ),
  //         child: Padding(
  //           padding: EdgeInsets.all(28.w),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               // Handle
  //               Container(
  //                 width: 40.w,
  //                 height: 4.h,
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey[300],
  //                   borderRadius: BorderRadius.circular(2.r),
  //                 ),
  //               ),
  //               SizedBox(height: 20.h),
  //               // Header
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     'انضم للفرصة',
  //                     style: TextStyle(
  //                       fontSize: 18.sp,
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.black87,
  //                     ),
  //                   ),
  //                   GestureDetector(
  //                     onTap: () => Navigator.pop(dialogContext),
  //                     child: Icon(Icons.close,
  //                         size: 24.sp, color: Colors.grey[600]),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(height: 20.h),
  //               // Chance info
  //               Text(
  //                 chanceAd.title,
  //                 style: TextStyle(
  //                   fontSize: 16.sp,
  //                   fontWeight: FontWeight.w500,
  //                   color: Colors.black87,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //               SizedBox(height: 16.h),
  //               // Amount Input
  //               Container(
  //                 width: double.infinity,
  //                 padding: EdgeInsets.all(16.w),
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey[100],
  //                   borderRadius: BorderRadius.circular(8.r),
  //                 ),
  //                 child: TextField(
  //                   controller: amountController,
  //                   keyboardType:
  //                       const TextInputType.numberWithOptions(decimal: true),
  //                   decoration: InputDecoration(
  //                     hintText: 'أدخل المبلغ بالجنيه',
  //                     border: InputBorder.none,
  //                     hintStyle: TextStyle(
  //                       fontSize: 16.sp,
  //                       color: Colors.grey[500],
  //                     ),
  //                   ),
  //                   style: TextStyle(
  //                     fontSize: 16.sp,
  //                     color: Colors.black87,
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(height: 20.h),
  //               // Confirm Button
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton(
  //                   onPressed: () {
  //                     final inputText = amountController.text.trim();
  //                     final amount = double.tryParse(inputText);

  //                     if (inputText.isEmpty) {
  //                       ScaffoldMessenger.of(dialogContext).showSnackBar(
  //                         const SnackBar(content: Text('من فضلك أدخل مبلغ')),
  //                       );
  //                     } else if (amount == null) {
  //                       ScaffoldMessenger.of(dialogContext).showSnackBar(
  //                         const SnackBar(
  //                             content: Text('من فضلك أدخل رقم صحيح')),
  //                       );
  //                     } else if (amount < 1) {
  //                       ScaffoldMessenger.of(dialogContext).showSnackBar(
  //                         const SnackBar(
  //                             content: Text('الحد الأدنى للمساهمة 1 جنيه')),
  //                       );
  //                     } else {
  //                       Navigator.pop(dialogContext);
  //                       dialogContext.read<ChanceCubit>().joinChanceAd(
  //                             JoinChanceAdParams(
  //                               adId: chanceAd.id,
  //                               amount: amount,
  //                             ),
  //                           );
  //                     }
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.red,
  //                     padding: EdgeInsets.symmetric(vertical: 16.h),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(8.r),
  //                     ),
  //                   ),
  //                   child: Text(
  //                     'تأكيد الانضمام',
  //                     style: TextStyle(
  //                       fontSize: 16.sp,
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _showJoinDialog(ChanceAdEntity chanceAd, ChanceCubit chanceCubit) {
    final TextEditingController amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Padding(
            padding: EdgeInsets.all(28.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // نفس الـ UI
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'انضم للفرصة',
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ManageVibration.vibrate();
                        Navigator.pop(bottomSheetContext);
                      },
                      child: Icon(Icons.close,
                          size: 36.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  chanceAd.title,
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextField(
                    controller: amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'أدخل المبلغ بالجنيه',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 32.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 32.sp,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ManageVibration.vibrate();
                      final inputText = amountController.text.trim();
                      final amount = double.tryParse(inputText);

                      if (inputText.isEmpty) {
                        ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                          const SnackBar(content: Text('من فضلك أدخل مبلغ')),
                        );
                      } else if (amount == null) {
                        ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                          const SnackBar(
                              content: Text('من فضلك أدخل رقم صحيح')),
                        );
                      } else if (amount < 1) {
                        ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                          const SnackBar(
                              content: Text('الحد الأدنى للمساهمة 1 جنيه')),
                        );
                      } else {
                        Navigator.pop(bottomSheetContext);

                        // استخدم الـ cubit مباشرة
                        chanceCubit.joinChanceAd(
                          JoinChanceAdParams(
                            adId: chanceAd.id,
                            amount: amount,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'تأكيد الانضمام',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    try {
      // Remove listeners first with proper checks
      _tabController.removeListener(_onTabChanged);
      _searchController.removeListener(_onSearchChanged);

      // Remove scroll listeners with proper checks
      if (_mainScrollController.hasClients &&
          _mainScrollController.hasListeners) {
        _mainScrollController.removeListener(() => _syncFromMain());
      }

      if (_availableController.hasClients &&
          _availableController.hasListeners) {
        _availableController
            .removeListener(() => _syncToMain(_availableController));
      }

      if (_favoriteController.hasClients && _favoriteController.hasListeners) {
        _favoriteController
            .removeListener(() => _syncToMain(_favoriteController));
      }

      if (_expireController.hasClients && _expireController.hasListeners) {
        _expireController.removeListener(() => _syncToMain(_expireController));
      }

      if (_myChanceController.hasClients && _myChanceController.hasListeners) {
        _myChanceController
            .removeListener(() => _syncToMain(_myChanceController));
      }
    } catch (e) {
      print('Error during controller disposal: $e');
    }

    // Then dispose controllers
    _tabController.dispose();
    _searchController.dispose();
    _mainScrollController.dispose();
    _availableController.dispose();
    _favoriteController.dispose();
    _expireController.dispose();
    _myChanceController.dispose();

    super.dispose();
  }
}
