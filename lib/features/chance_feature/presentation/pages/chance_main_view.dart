// chance_main_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../star_feature/presentation/widgets/talent_card/sticky_tab_bar_delegate.dart';
import 'chance_detail_view.dart';

// Main View
class ChanceMainView extends StatefulWidget {
  const ChanceMainView({super.key});

  @override
  State<ChanceMainView> createState() => _ChanceMainViewState();
}

class _ChanceMainViewState extends State<ChanceMainView>
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
  }

  void _onSearchChanged() {
    setState(() {
      _isCategoriesVisible = _searchController.text.isNotEmpty;
    });
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
              toolbarHeight: 60.h,
              titleSpacing: 16.w,
              leading: Icon(Icons.arrow_back_ios, size: 20.sp, color: Colors.black87),
              centerTitle: false,
              title: Text(
                'Chance',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '(22/1500) Winners',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text('🏆', style: TextStyle(fontSize: 16.sp)),
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
        body: _buildTabContent(),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: EdgeInsets.all(16.w),
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2E3440), Color(0xFF4C566A)],
                ),
              ),
            ),
            // Building silhouettes
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120.h,
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
            // Overlay text
            Positioned(
              top: 16.h,
              left: 16.w,
              right: 16.w,
              child: Text(
                'Join by buying a share in the product. Everyone who joins enters the draw, and one lucky winner will get the product.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      'Cars', 'Real Estate', 'Electronics', 'Home Appliances',
      'Furniture', 'Fashion & Clothing', 'Watches & Accessories',
      'Sports Equipment', 'Books & Stationery', 'Pets & Pet Supplies',
      'Health & Beauty Products', 'Toys & Kids Items', 'Tools & Hardware'
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
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
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
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

  Widget _buildTabContent() {
    // Return content based on selected tab index (controlled by StickyTabBarDelegate)
    switch (_selectedTabIndex) {
      case 0: // Available
        return _buildAvailableTab();
      case 1: // Favorite
        return _buildFavoriteTab();
      case 2: // History
        return _buildHistoryTab();
      case 3: // My Talent
        return _buildMyTalentTab();
      default:
        return _buildAvailableTab();
    }
  }

  Widget _buildAvailableTab() {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                return _buildChanceCard(
                  title: 'Win a trip to the Maldives',
                  price: 2000,
                  endDate: 'Ending Soon',
                  progress: 0.75,
                  participants: 120,
                  views: 507,
                  images: [
                    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop',
                  ],
                  status: ChanceStatus.available,
                );
              } else {
                return _buildChanceCard(
                  title: 'Win iPhone 16',
                  price: 20000,
                  endDate: 'Ended',
                  progress: 1.0,
                  participants: 200,
                  views: 507,
                  images: [
                    'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=300&fit=crop',
                  ],
                  status: ChanceStatus.winner,
                  winnerName: 'Moaz Mohamed',
                );
              }
            },
            childCount: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteTab() {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildChanceCard(
                title: 'Win a trip to the Maldives',
                price: 2000,
                endDate: 'Ending Soon',
                progress: 0.75,
                participants: 120,
                views: 507,
                images: [
                  'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop',
                ],
                status: ChanceStatus.available,
                isFavorite: true,
              );
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildChanceCard(
                title: 'Win iPhone 16',
                price: 20000,
                endDate: 'Ended',
                progress: 1.0,
                participants: 200,
                views: 507,
                images: [
                  'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=300&fit=crop',
                ],
                status: ChanceStatus.winner,
                winnerName: 'Moaz Mohamed',
              );
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildMyTalentTab() {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildChanceCard(
                title: 'Win a trip to the Maldives',
                price: 2000,
                endDate: 'Ending Soon',
                progress: 0.75,
                participants: 120,
                views: 507,
                images: [
                  'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop',
                ],
                status: ChanceStatus.available,
                isMyChance: true,
              );
            },
            childCount: 1,
          ),
        ),
      ],
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
              description: 'Win a trip to the Maldives Win a trip to the Maldives...',
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
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
                  height: 200.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
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
                      // Toggle favorite
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
                        size: 16.sp,
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
                            color: index == 0 ? Colors.white : Colors.white.withOpacity(0.5),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
            // Content Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$price EGP',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        endDate,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: status == ChanceStatus.available 
                              ? Colors.orange : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Progress Bar
                  Text(
                    '${(progress * 100).toInt()}% claimed',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      status == ChanceStatus.winner ? Colors.green : Colors.orange,
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
                              fontSize: 11.sp,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A8A),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.visibility, color: Colors.white, size: 12.sp),
                                SizedBox(width: 4.w),
                                Text(
                                  '${views}K views',
                                  style: TextStyle(
                                    fontSize: 10.sp,
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
                                  description: 'Win a trip to the Maldives Win a trip to the Maldives...',
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: status == ChanceStatus.winner 
                                ? Colors.orange : Colors.red,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            status == ChanceStatus.winner ? 'Winner' : 'Join Now',
                            style: TextStyle(
                              fontSize: 12.sp,
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
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            // Blurred background effect
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
            // Dialog content
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Winner crown
                  Text('👑', style: TextStyle(fontSize: 32.sp)),
                  SizedBox(height: 12.h),
                  // Winner avatar
                  CircleAvatar(
                    radius: 30.r,
                    backgroundImage: const NetworkImage(
                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Winner details
                  Text(
                    winnerName,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '21/3/2024',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '10000 EGP',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'iPhone 16',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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