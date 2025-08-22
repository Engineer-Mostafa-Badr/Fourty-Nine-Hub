import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/user_star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/talent_card_widget.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/profile_video_cards.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfilePageView extends StatefulWidget {
  final UserStarEntity user;
  final List<StarEntity> userVideos;

  const ProfilePageView({
    super.key,
    required this.user,
    required this.userVideos,
  });

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isSubscribed = false;

  // Mock playlists data
  late List<PlaylistEntity> _mockPlaylists;

  // Extended videos list for better scrolling
  late List<StarEntity> _extendedUserVideos;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeMockPlaylists();
  }

  void _initializeMockPlaylists() {
    // Create more mock videos for better scrolling experience
    final List<StarEntity> extendedVideos = [];

    // Add original videos multiple times with variations
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < widget.userVideos.length; j++) {
        final originalVideo = widget.userVideos[j];
        extendedVideos.add(StarEntity(
          id: '${originalVideo.id}_$i$j',
          title: '${originalVideo.title} - Part ${i + 1}',
          description:
              '${originalVideo.description} - Extended version ${i + 1}',
          user: originalVideo.user,
          mediaUrl: originalVideo.mediaUrl,
          totalViews: originalVideo.totalViews + (i * 1000),
          averageRating: originalVideo.averageRating,
          isApproved: originalVideo.isApproved,
          haveStories: originalVideo.haveStories,
          storyCount: originalVideo.storyCount,
          createdAt: DateTime.now().subtract(Duration(days: i + j)),
        ));
      }
    }

    // Update userVideos with extended list
    _extendedUserVideos = extendedVideos;

    _mockPlaylists = [
      PlaylistEntity(
        id: '1',
        name: 'Heart Touching - Playlist',
        description: 'Beautiful collection of heart touching nasheeds',
        videos: _extendedUserVideos.take(25).toList(),
        thumbnailUrl: 'assets/images/testforvideo.jpg',
        createdAt: DateTime.now().subtract(Duration(days: 30)),
      ),
      PlaylistEntity(
        id: '2',
        name: 'Heart Touching - Playlist',
        description: 'Another beautiful collection',
        videos: _extendedUserVideos.skip(10).take(30).toList(),
        thumbnailUrl: 'assets/images/testforvideo.jpg',
        createdAt: DateTime.now().subtract(Duration(days: 60)),
      ),
      PlaylistEntity(
        id: '3',
        name: 'Heart Touching - Playlist',
        description: 'More inspiring content',
        videos: _extendedUserVideos.take(35).toList(),
        thumbnailUrl: 'assets/images/testforvideo.jpg',
        createdAt: DateTime.now().subtract(Duration(days: 90)),
      ),
      PlaylistEntity(
        id: '4',
        name: 'Heart Touching - Playlist',
        description: 'Latest collection',
        videos: _extendedUserVideos.skip(5).take(40).toList(),
        thumbnailUrl: 'assets/images/testforvideo.jpg',
        createdAt: DateTime.now().subtract(Duration(days: 15)),
      ),
      PlaylistEntity(
        id: '5',
        name: 'Heart Touching - Playlist',
        description: 'Premium collection',
        videos: _extendedUserVideos.skip(15).take(28).toList(),
        thumbnailUrl: 'assets/images/testforvideo.jpg',
        createdAt: DateTime.now().subtract(Duration(days: 45)),
      ),
      PlaylistEntity(
        id: '6',
        name: 'Heart Touching - Playlist',
        description: 'Special collection',
        videos: _extendedUserVideos.skip(20).take(32).toList(),
        thumbnailUrl: 'assets/images/testforvideo.jpg',
        createdAt: DateTime.now().subtract(Duration(days: 75)),
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode ? Colors.black : Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: context.isDarkMode ? Colors.black : Colors.white,
            elevation: 0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: () => _showProfileOptions(),
              ),
            ],
          ),

          // Profile Header
          SliverToBoxAdapter(
            child: _buildProfileHeader(),
          ),

          // Sticky Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _ProfileTabBarDelegate(
              tabController: _tabController,
              context: context,
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHomeTab(),
                _buildVideosTab(),
                _buildPlaylistsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Banner Section
          _buildBannerSection(),
          SizedBox(height: 16.h),

          // Profile Info Section
          _buildProfileInfoSection(),
          SizedBox(height: 16.h),

          // Subscribe Button Section
          _buildSubscribeSection(),
        ],
      ),
    );
  }

  Widget _buildBannerSection() {
    return Container(
      width: double.infinity,
      height: 120.h, // Reduced height to match mobile proportion
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF7B68EE),
            Color(0xFF9A7AA0),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative shapes with better proportions
          Positioned(
            top: 15,
            left: 15,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Positioned(
            top: 25,
            right: 20,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 30,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoSection() {
    return Row(
      children: [
        // Profile Picture with better sizing
        Container(
          width: 70.w,
          height: 70.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: context.isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: ClipOval(
            child: widget.user.image.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: widget.user.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child:
                          Icon(Icons.person, size: 35, color: Colors.grey[600]),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child:
                          Icon(Icons.person, size: 35, color: Colors.grey[600]),
                    ),
                  )
                : Container(
                    color: Colors.grey[300],
                    child:
                        Icon(Icons.person, size: 35, color: Colors.grey[600]),
                  ),
          ),
        ),
        SizedBox(width: 16.w),

        // Name and Stats with adjusted font sizes
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.user.firstName} ${widget.user.lastName}",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "@${widget.user.firstName.toLowerCase()}",
                style: TextStyle(
                  fontSize: 13.sp,
                  color:
                      context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "${widget.userVideos.length} videos",
                style: TextStyle(
                  fontSize: 13.sp,
                  color:
                      context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubscribeSection() {
    return Row(
      children: [
        // Subscribe Button with better proportions
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _isSubscribed = !_isSubscribed;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isSubscribed ? Colors.grey[300] : Colors.black,
              foregroundColor: _isSubscribed ? Colors.black : Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isSubscribed ? 'Subscribed' : 'Subscribe',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_isSubscribed) ...[
                  SizedBox(width: 6.w),
                  Icon(Icons.notifications, size: 16.sp),
                ],
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Join Button with better sizing
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: context.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: IconButton(
            onPressed: () {
              // Handle join action
            },
            icon: Icon(
              Icons.group_add,
              color: context.isDarkMode ? Colors.white : Colors.black,
              size: 20,
            ),
            padding: EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),

          // For You Section - Horizontal Scroll
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'For You',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to see all
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFF4A90E2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Horizontal Scrollable List for "For You"
          SizedBox(
            height: 220.h, // Fixed height for horizontal scroll
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 10, // Increased items for better scrolling
              itemBuilder: (context, index) {
                final video =
                    _extendedUserVideos[index % _extendedUserVideos.length];
                return Container(
                  width: 160.w, // Fixed width for each card
                  margin: EdgeInsets.only(right: 12.w),
                  child: _buildHorizontalVideoCard(video, index),
                );
              },
            ),
          ),
          SizedBox(height: 24.h),

          // Trending Now Section - Horizontal Scroll
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trending Now',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to see all
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFF4A90E2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Horizontal Scrollable List for "Trending"
          SizedBox(
            height: 220.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 12, // More items
              itemBuilder: (context, index) {
                final video = _extendedUserVideos[
                    (index + 5) % _extendedUserVideos.length];
                return Container(
                  width: 160.w,
                  margin: EdgeInsets.only(right: 12.w),
                  child: _buildHorizontalVideoCard(
                      video, index + 100), // Different index for variety
                );
              },
            ),
          ),
          SizedBox(height: 24.h),

          // Popular This Week - Grid View
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Popular This Week',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Grid View with 2 columns
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.75, // Adjusted for better proportions
              ),
              itemCount: 6, // Show 6 items in grid
              itemBuilder: (context, index) {
                final video = _extendedUserVideos[
                    (index + 10) % _extendedUserVideos.length];
                return _buildGridVideoCard(video, index);
              },
            ),
          ),
          SizedBox(height: 24.h),

          // Recent Uploads Section - Vertical List
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Uploads',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _tabController.animateTo(1); // Switch to Videos tab
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFF4A90E2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Vertical list of recent videos
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: 8, // Show 8 recent videos
            itemBuilder: (context, index) {
              final video = _extendedUserVideos[index];
              return ProfileVideoCards.buildHistoryVideoItem(
                context,
                video,
                onTap: () => _navigateToVideo(video),
              );
            },
          ),

          // Most Watched Section - Horizontal
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Most Watched',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          SizedBox(height: 12.h),

          SizedBox(
            height: 180.h, // Smaller cards for most watched
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 15,
              itemBuilder: (context, index) {
                final video = _extendedUserVideos[
                    (index + 3) % _extendedUserVideos.length];
                return Container(
                  width: 140.w, // Smaller width
                  margin: EdgeInsets.only(right: 10.w),
                  child: _buildCompactVideoCard(video, index),
                );
              },
            ),
          ),

          SizedBox(height: 32.h), // Bottom padding
        ],
      ),
    );
  }

// New method for horizontal video cards with better proportions
  Widget _buildHorizontalVideoCard(StarEntity video, int index) {
    return GestureDetector(
      onTap: () => _navigateToVideo(video),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.grey[300],
              image: DecorationImage(
                image: AssetImage('assets/images/testforvideo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Play button overlay
                Center(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                // Duration
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${(index % 10 + 3)}:${(index % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Views count badge
                if (index % 3 == 0)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'HOT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8.h),

          // Title
          Text(
            video.title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),

          // Views and time
          Text(
            "${(video.totalViews + (index * 1000)).toShortScale} views",
            style: TextStyle(
              fontSize: 11.sp,
              color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          SizedBox(height: 4.h),

          // Rating stars
          Row(
            children: List.generate(
              5,
              (starIndex) => Icon(
                starIndex < video.averageRating
                    ? Icons.star
                    : Icons.star_outline,
                size: 12,
                color: starIndex < video.averageRating
                    ? Colors.amber
                    : Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

// Updated grid video card with better proportions
  Widget _buildGridVideoCard(StarEntity video, int index) {
    return GestureDetector(
      onTap: () => _navigateToVideo(video),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.grey[300],
                image: DecorationImage(
                  image: AssetImage('assets/images/testforvideo.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                  // Duration
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${(index % 15 + 5)}:${((index * 7) % 60).toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // New badge for some items
                  if (index % 2 == 0)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(0xFF4A90E2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // Title
          Text(
            video.title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),

          // Stats row
          Row(
            children: [
              Icon(
                Icons.play_circle_outline,
                size: 12,
                color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  (video.totalViews + (index * 2000)).toShortScale,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: context.isDarkMode
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// New compact card for "Most Watched" section
  Widget _buildCompactVideoCard(StarEntity video, int index) {
    return GestureDetector(
      onTap: () => _navigateToVideo(video),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Container(
            height: 90.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color: Colors.grey[300],
              image: DecorationImage(
                image: AssetImage('assets/images/testforvideo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Duration only
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      '${(index % 20 + 2)}:${((index * 3) % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),

          // Title
          Text(
            video.title,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 3.h),

          // Views count
          Text(
            "${(video.totalViews / 1000).toStringAsFixed(1)}K views",
            style: TextStyle(
              fontSize: 10.sp,
              color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideosTab() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.h),
      itemCount: _extendedUserVideos.length, // Use extended list
      itemBuilder: (context, index) {
        final video = _extendedUserVideos[index];
        return ProfileVideoCards.buildHistoryVideoItem(
          context,
          video,
          onTap: () => _navigateToVideo(video),
        );
      },
    );
  }

  Widget _buildPlaylistsTab() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.h),
      itemCount: _mockPlaylists.length,
      itemBuilder: (context, index) {
        final playlist = _mockPlaylists[index];
        return ProfileVideoCards.buildPlaylistItem(
          context,
          playlist,
          onTap: () => _navigateToPlaylist(playlist),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: context.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildForYouGrid() {
    final forYouVideos = widget.userVideos.take(2).toList();
    return Row(
      children: forYouVideos.asMap().entries.map((entry) {
        final index = entry.key;
        final video = entry.value;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index == 0 ? 8.w : 0),
            child: _buildGridVideoCard(video, index),
          ),
        );
      }).toList(),
    );
  }

  void _navigateToVideo(StarEntity video) {
    // Navigate to video player
    // You can implement navigation logic here
    print('Navigate to video: ${video.title}');
  }

  void _navigateToPlaylist(PlaylistEntity playlist) {
    // Navigate to playlist view
    // You can implement navigation logic here
    print('Navigate to playlist: ${playlist.name}');
  }

  void _showProfileOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.share,
                  color: context.isDarkMode ? Colors.white : Colors.black),
              title: Text('Share',
                  style: TextStyle(
                      color: context.isDarkMode ? Colors.white : Colors.black)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.block, color: Colors.red),
              title: Text('Block user', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.report, color: Colors.red),
              title: Text('Report user', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ProfileTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final BuildContext context;

  _ProfileTabBarDelegate({
    required this.tabController,
    required this.context,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: context.isDarkMode ? Colors.black : Colors.white,
      elevation: overlapsContent ? 4.0 : 0.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: TabBar(
          controller: tabController,
          isScrollable: false,
          indicatorColor: context.isDarkMode ? Colors.white : Colors.black,
          indicatorWeight: 2,
          labelColor: context.isDarkMode ? Colors.white : Colors.black,
          unselectedLabelColor:
              context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
          labelStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.normal,
          ),
          tabs: [
            Tab(text: 'Home'),
            Tab(text: 'Videos'),
            Tab(text: 'Playlists'),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
