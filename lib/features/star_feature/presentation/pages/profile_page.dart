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
          title: '${originalVideo.title}',
          description: '${originalVideo.description}',
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
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            // App Bar
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              floating: false,
              pinned: true,
              expandedHeight: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Winners 🏆',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
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
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildHomeTab(),
            _buildVideosTab(),
            _buildPlaylistsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          // Banner Section
          _buildBannerSection(),
          SizedBox(height: 16.h),

          // Profile Info Section
          _buildProfileInfoSection(),
        ],
      ),
    );
  }

  Widget _buildBannerSection() {
    return Container(
      width: double.infinity,
      height: 100.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5A8F9C),
            Color(0xFF7BA5B0),
            Color(0xFF6A99A6),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative buildings/shapes
          Positioned(
            bottom: 0,
            left: 30,
            child: _buildBuilding(50, 60, Colors.black87),
          ),
          Positioned(
            bottom: 0,
            // center: true,
            left: MediaQuery.of(context).size.width / 2 - 40,
            child: _buildBuilding(70, 90, Colors.black87),
          ),
          Positioned(
            bottom: 0,
            right: 50,
            child: _buildBuilding(55, 70, Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildBuilding(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: Column(
        children: [
          // Building windows pattern
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Wrap(
                spacing: 2,
                runSpacing: 2,
                children: List.generate(
                  12,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    color: Colors.grey[300]?.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoSection() {
    return Column(
      children: [
        Row(
          children: [
            // Profile Picture
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: widget.user.image.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: widget.user.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.person,
                              size: 28, color: Colors.grey[600]),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.person,
                              size: 28, color: Colors.grey[600]),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child:
                            Icon(Icons.person, size: 28, color: Colors.grey[600]),
                      ),
              ),
            ),
            SizedBox(width: 12.w),

            // Name and Stats
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Heart Touching",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "@heart · ${widget.userVideos.length} videos",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // For You Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 16.h),
            child: Text(
              'For You',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // For You Grid - 2 columns
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: _buildVideoCard(_extendedUserVideos[0], 0),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildVideoCard(_extendedUserVideos[1], 1),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // New Song 2020 Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'New Song 2020',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Vertical list of videos
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: 6,
            itemBuilder: (context, index) {
              final video = _extendedUserVideos[index % _extendedUserVideos.length];
              return _buildListVideoItem(video, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(StarEntity video, int index) {
    return GestureDetector(
      onTap: () => _navigateToVideo(video),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with overlay elements
          Container(
            height: 180.h,
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
                // Heart icon - top left
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
                // Volume icon - top right
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                // Duration - bottom right
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '7:54',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),

          // Video info with profile pic
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[300],
                backgroundImage: video.user.image.isNotEmpty
                    ? NetworkImage(video.user.image)
                    : null,
                child: video.user.image.isEmpty
                    ? Icon(Icons.person, size: 16, color: Colors.grey[600])
                    : null,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Heart Touching Nasheed",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "507K views · 10 months ago",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Star rating
                    Row(
                      children: List.generate(
                        5,
                        (starIndex) => Icon(
                          starIndex < 3 ? Icons.star : Icons.star_border,
                          size: 14,
                          color: starIndex < 3 ? Colors.amber : Colors.grey[400],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showMoreOptions(context, video),
                child: Icon(
                  Icons.more_vert,
                  size: 18,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListVideoItem(StarEntity video, int index) {
    return GestureDetector(
      onTap: () => _navigateToVideo(video),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              width: 120.w,
              height: 75.h,
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
                  // Volume icon overlay
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.volume_up,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                  // Duration
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        '7:54',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),

            // Video info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Heart Touching Nasheed",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "RAV",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "507K Views · 10 Months Ago",
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // More button
            GestureDetector(
              onTap: () => _showMoreOptions(context, video),
              child: Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Icon(
                  Icons.more_vert,
                  size: 18,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosTab() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: _extendedUserVideos.length,
      itemBuilder: (context, index) {
        final video = _extendedUserVideos[index];
        return _buildListVideoItem(video, index);
      },
    );
  }

  Widget _buildPlaylistsTab() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
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

  void _navigateToVideo(StarEntity video) {
    print('Navigate to video: ${video.title}');
  }

  void _navigateToPlaylist(PlaylistEntity playlist) {
    print('Navigate to playlist: ${playlist.name}');
  }

  void _showMoreOptions(BuildContext context, StarEntity video) {
    TalentCard.showYouTubeOptions(context, video);
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
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: tabController,
        isScrollable: false,
        indicatorColor: Colors.black,
        indicatorWeight: 2,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.normal,
        ),
        tabs: [
          Tab(text: 'Home'),
          Tab(text: 'Videos'),
          Tab(text: 'Playlists'),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}