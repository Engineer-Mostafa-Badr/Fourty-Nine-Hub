// chance_main_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../service_locator/service_locator.dart';
import '../controller/cubit/chance_cubit.dart';
import '../controller/cubit/chance_states.dart';
import '../../domain/entity/chance_ad_entity.dart';
import '../../domain/use_case/join_chance_ad_use_case.dart';
import '../../../../service_locator/chance_service_locator.dart';

import '../../../star_feature/presentation/widgets/talent_card/sticky_tab_bar_delegate.dart';
import '../widgets/floating_action_button_widget.dart';
import 'chance_detail_view.dart';
import 'chance_ad_details_view.dart';

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
  int _selectedTabIndex = 0;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _searchController.addListener(_onSearchChanged);

    // Auto refresh data every 30 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted && !_isSearching) {
        _refreshChanceAds();
      }
    });
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم الانضمام للفرصة بنجاح!'),
              backgroundColor: Colors.green,
            ),
          );
          _refreshChanceAds();
        } else if (state.status == ChanceStates.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('فشل في الانضمام للفرصة، حاول مرة أخرى'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<ChanceCubit, ChanceState>(
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
                        tabTitles: [
                          context.isArabic ? 'متاح' : 'Available',
                          context.isArabic ? 'مفضلة' : 'Favorite',
                          context.isArabic ? 'منتهي' : 'Expire',
                          context.isArabic ? 'موهبتي' : 'My Talent',
                        ],
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
                        tabTitles: [
                          context.isArabic ? 'متاح' : 'Available',
                          context.isArabic ? 'مفضلة' : 'Favorite',
                          context.isArabic ? 'منتهي' : 'Expire',
                          context.isArabic ? 'موهبتي' : 'My Talent',
                        ],
                        // onSearchChanged: _onSearchChanged,
                      ),
                    ),
                ];
              },
              body: _buildTabContent(state),
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
      height: 200.h,
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
      case 2: // Expire
        return _buildExpireTab(state);
      case 3: // My Talent
        return _buildMyTalentTab(state);
      default:
        return _buildAvailableTab(state);
    }
  }

  Widget _buildAvailableTab(ChanceState state) {
    final List<ChanceAdEntity> ads =
        _isSearching && _searchController.text.isNotEmpty
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

  Widget _buildExpireTab(ChanceState state) {
    final List<ChanceAdEntity> expiredAds = state.expiredChanceAds ?? [];

    if (expiredAds.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد إعلانات منتهية',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final ad = expiredAds[index];
              return _buildExpiredChanceCard(ad);
            },
            childCount: expiredAds.length,
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
      images: imageUrls.isNotEmpty
          ? imageUrls
          : ['https://via.placeholder.com/400x300'],
      status: status,
      isFavorite: ad.isFavorite, // Use actual favorite status from entity
      isMyChance: isMyChance,
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
                  description: "",
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
                  height: 250.h,
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
                      if (adId != null && state.chanceAds != null) {
                        try {
                          final updatedAd = state.chanceAds!.firstWhere(
                            (ad) => ad.id == adId,
                          );
                          currentFavoriteStatus = updatedAd.isFavorite;
                        } catch (e) {
                          // Ad not found in state, keep original favorite status
                          currentFavoriteStatus = isFavorite;
                        }
                      }

                      return GestureDetector(
                        onTap: () {
                          if (adId != null) {
                            context
                                .read<ChanceCubit>()
                                .toggleChanceAdFavorite(adId);
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
                                  '${_formatViews(views)} views',
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
                          if (status == ChanceStatus.winner &&
                              chanceAd != null) {
                            _showWinnerDialogFromAd(chanceAd);
                          } else if (adId != null && chanceAd != null) {
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
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(bottomSheetContext),
                      child: Icon(Icons.close,
                          size: 24.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  chanceAd.title,
                  style: TextStyle(
                    fontSize: 16.sp,
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
                        fontSize: 16.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
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
                        fontSize: 16.sp,
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
    _tabController.removeListener(_onTabChanged);
    _searchController.removeListener(_onSearchChanged);
    _tabController.dispose();
    _searchController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }
}
