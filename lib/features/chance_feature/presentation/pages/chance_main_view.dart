// chance_main_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../service_locator/service_locator.dart';
import '../controller/cubit/chance_cubit.dart';
import '../controller/cubit/chance_states.dart';
import '../../domain/entity/chance_ad_entity.dart';
import '../../../../service_locator/chance_service_locator.dart';

import '../../../star_feature/presentation/widgets/talent_card/sticky_tab_bar_delegate.dart';
import 'chance_detail_view.dart';

enum ChanceStatus { available, winner, ended }

// Main View
class ChanceMainView extends StatelessWidget {
  const ChanceMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ChanceCubit>()..getAllChanceAds(),
      child: const _ChanceMainViewBody(),
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
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _searchController.addListener(_onSearchChanged);
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
      case 3: // My Talent
        context.read<ChanceCubit>().getMyChanceAds();
        break;
      default:
        // Available tab or History - data already loaded
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
    return BlocBuilder<ChanceCubit, ChanceState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Header AppBar
            SliverAppBar(
              pinned: true,
              floating: false,
              snap: false,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.white,
              toolbarHeight: 30.h,
              titleSpacing: 24.w,
              leading: Icon(Icons.arrow_back_ios,
                  size: 28.sp, color: Colors.black87),
              centerTitle: false,
              title: Text(
                context.isArabic ? 'فرصة' : 'Chance',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '(22/1500) ${context.isArabic ? 'فائز' : 'Winner'}',
                        style: TextStyle(
                          fontSize: 22.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text('🏆', style: TextStyle(fontSize: 28.sp)),
                    ],
                  ),
                ),
              ],
            ),

            // Banner - يختفي مع الـ scroll عند البحث
            if (!_isSearching)
              SliverToBoxAdapter(
                child: _buildBanner(),
              ),

            // Categories Section (if visible during search)
            if (_isCategoriesVisible && _isSearching)
              SliverToBoxAdapter(
                child: _buildCategoriesSection(),
              ),

            // Sticky Tabs - Normal state
            if (!_isSearching)
              SliverPersistentHeader(
                pinned: true,
                delegate: StickyTabBarDelegate(
                  tabController: _tabController,
                  context: context,
                  onSearchTap: _toggleSearch,
                  showSearchField: false,
                ),
              ),

            // Sticky Tabs - Search state
            if (_isSearching)
              SliverPersistentHeader(
                pinned: true,
                delegate: StickyTabBarDelegate(
                  tabController: _tabController,
                  context: context,
                  onSearchTap: _toggleSearch,
                  showSearchField: true,
                  searchController: _searchController,
                  // onSearchChanged: _onSearchChanged,
                ),
              ),
          ];
        },
        body: _buildTabContent(state),
      ),
        );
      },
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: EdgeInsets.all(24.w),
      height: 300.h,
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
          height: 180.h,
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

  Widget _buildTabContent(ChanceState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isFailure) {
      return const Center(
        child: Text(
          'خطأ في تحميل البيانات',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      );
    }

    // Return content based on selected tab index (controlled by StickyTabBarDelegate)
    switch (_selectedTabIndex) {
      case 0: // Available
        return _buildAvailableTab(state);
      case 1: // Favorite
        return _buildFavoriteTab(state);
      case 2: // History
        return _buildHistoryTab(state);
      case 3: // My Talent
        return _buildMyTalentTab(state);
      default:
        return _buildAvailableTab(state);
    }
  }

  Widget _buildAvailableTab(ChanceState state) {
    final List<ChanceAdEntity> ads = _isSearching && _searchController.text.isNotEmpty
        ? (state.searchResults ?? [])
        : (state.chanceAds ?? []);

    if (ads.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد إعلانات متاحة',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final ad = ads[index];
              return _buildChanceCardFromEntity(ad);
            },
            childCount: ads.length,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteTab(ChanceState state) {
    final List<ChanceAdEntity> favoriteAds = state.favoriteChanceAds ?? [];

    if (favoriteAds.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد إعلانات مفضلة',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final ad = favoriteAds[index];
              return _buildChanceCardFromEntity(ad, isFavorite: true);
            },
            childCount: favoriteAds.length,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab(ChanceState state) {
    // For now, show completed ads from main list
    final List<ChanceAdEntity> historyAds = (state.chanceAds ?? [])
        .where((ad) => ad.isComplete)
        .toList();

    if (historyAds.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد إعلانات مكتملة',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final ad = historyAds[index];
              return _buildChanceCardFromEntity(ad);
            },
            childCount: historyAds.length,
          ),
        ),
      ],
    );
  }

  Widget _buildMyTalentTab(ChanceState state) {
    final List<ChanceAdEntity> myAds = state.myChanceAds ?? [];

    if (myAds.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد إعلانات خاصة بك',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final ad = myAds[index];
              return _buildChanceCardFromEntity(ad, isMyChance: true);
            },
            childCount: myAds.length,
          ),
        ),
      ],
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
      participants: ad.contributors,
      views: ad.views,
      images: imageUrls.isNotEmpty ? imageUrls : ['https://via.placeholder.com/400x300'],
      status: status,
      isFavorite: isFavorite,
      isMyChance: isMyChance,
      adId: ad.id,
    );
  }

  Widget _buildChanceCard({
    required String title,
    required int price,
    required String endDate,
    required double progress,
    required int participants,
    required int views,
    required List<String> images,
    required ChanceStatus status,
    String? winnerName,
    bool isFavorite = false,
    bool isMyChance = false,
    String? adId,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChanceDetailView(
              title: title,
              price: price,
              images: images,
              progress: progress,
              participants: participants,
              views: views,
              description:
                  'Win a trip to the Maldives Win a trip to the Maldives...',
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
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
                  height: 350.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12.r)),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12.r)),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 200.h,
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
                  top: 12.h,
                  left: 12.w,
                  child: GestureDetector(
                    onTap: () {
                      if (adId != null) {
                        context.read<ChanceCubit>().toggleChanceAdFavorite(adId);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 30.sp,
                      ),
                    ),
                  ),
                ),
                // Carousel Indicators
                if (images.length > 1)
                  Positioned(
                    bottom: 12.h,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: images.map((image) {
                        int index = images.indexOf(image);
                        return Container(
                          width: 6.w,
                          height: 6.h,
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == 0
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
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
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$price EGP',
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        endDate,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
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
                    '${(progress * 100).toInt()}% claimed',
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      status == ChanceStatus.winner
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Stats and Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '$participants participants',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A8A),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.visibility,
                                    color: Colors.white, size: 12.sp),
                                SizedBox(width: 4.w),
                                Text(
                                  '${views}K views',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Action Button
                      GestureDetector(
                        onTap: () {
                          if (status == ChanceStatus.winner) {
                            _showWinnerDialog(winnerName ?? 'Unknown');
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChanceDetailView(
                                  title: title,
                                  price: price,
                                  images: images,
                                  progress: progress,
                                  participants: participants,
                                  views: views,
                                  description:
                                      'Win a trip to the Maldives Win a trip to the Maldives...',
                                ),
                              ),
                            );
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
                                ? 'Winner'
                                : 'Join Now',
                            style: TextStyle(
                              fontSize: 18.sp,
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

  void _showWinnerDialog(String winnerName) {
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
                              image:
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
                              '10000 EGP',
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
                      onTap: () => Navigator.pop(context),
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

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _searchController.removeListener(_onSearchChanged);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
