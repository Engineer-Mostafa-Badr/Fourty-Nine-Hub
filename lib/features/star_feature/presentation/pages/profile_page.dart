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
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:timeago/timeago.dart' as timeago;

// Mock Playlist Entity
class PlaylistEntity {
  final String id;
  final String name;
  final String description;
  final List<StarEntity> videos;
  final String thumbnailUrl;
  final DateTime createdAt;

  PlaylistEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.videos,
    required this.thumbnailUrl,
    required this.createdAt,
  });
}

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeMockPlaylists();
  }

  void _initializeMockPlaylists() {
    _mockPlaylists = [
      PlaylistEntity(
        id: '1',
        name: 'Heart Touching - Playlist',
        description: 'Beautiful collection of heart touching nasheeds',
        videos: widget.userVideos.take(5).toList(),
        thumbnailUrl: 'assets/images/testforvideo.jpg',
        createdAt: DateTime.now().subtract(Duration(days: 30)),
      ),
      PlaylistEntity(
        id: '2',
        name: 'Heart Touching - Playlist',
        description: 'Another beautiful collection',
        videos: widget.userVideos.skip(2).take(8).toList(),
        thumbnailUrl: 'assets/images/testforvideo.jpg',
        createdAt: DateTime.now().subtract(Duration(days: 60)),
      ),
      PlaylistEntity(
        id: '3',
        name: 'Heart Touching - Playlist',
        description: 'More inspiring content',
        videos: widget.userVideos.take(3).toList(),
        thumbnailUrl: 'assets/images/testforvideo.jpg',
        createdAt: DateTime.now().subtract(Duration(days: 90)),
      ),
      PlaylistEntity(
        id: '4',
        name: 'Heart Touching - Playlist',
        description: 'Latest collection',
        videos: widget.userVideos.skip(1).take(6).toList(),
        thumbnailUrl: 'assets/images/testforvideo.jpg',
        createdAt: DateTime.now().subtract(Duration(days: 15)),
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
      height: 150.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
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
          // Decorative shapes
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 30,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 40,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
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
        // Profile Picture
        Container(
          width: 80.w,
          height: 80.w,
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
                      child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
                    ),
                  )
                : Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
                  ),
          ),
        ),
        SizedBox(width: 16.w),

        // Name and Stats
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.user.firstName} ${widget.user.lastName}",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "@${widget.user.firstName.toLowerCase()}",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "${widget.userVideos.length} videos",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
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
        // Subscribe Button
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
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isSubscribed ? 'Subscribed' : 'Subscribe',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_isSubscribed) ...[
                  SizedBox(width: 8.w),
                  Icon(Icons.notifications, size: 18.sp),
                ],
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Join Button
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: context.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: IconButton(
            onPressed: () {
              // Handle join action
            },
            icon: Icon(
              Icons.group_add,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // For You Section
          _buildSectionHeader('For You'),
          SizedBox(height: 12.h),
          _buildForYouGrid(),
          SizedBox(height: 24.h),

          // New Song 2020 Section
          _buildSectionHeader('New Song 2020'),
          SizedBox(height: 12.h),
          _buildVideosList(widget.userVideos.take(3).toList()),
        ],
      ),
    );
  }

  Widget _buildVideosTab() {
    return _buildVideosList(widget.userVideos);
  }

  Widget _buildPlaylistsTab() {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: _mockPlaylists.length,
      itemBuilder: (context, index) {
        final playlist = _mockPlaylists[index];
        return _buildPlaylistCard(playlist);
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
      children: forYouVideos.map((video) => Expanded(
        child: Container(
          margin: EdgeInsets.only(right: forYouVideos.last == video ? 0 : 8.w),
          child: _buildGridVideoCard(video),
        ),
      )).toList(),
    );
  }

  Widget _buildGridVideoCard(StarEntity video) {
    return GestureDetector(
      onTap: () {
        // Navigate to video player
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Container(
            height: 120.h,
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
                // Heart icon
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 16,
                    ),
                  ),
                ),
                // Volume icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.volume_off,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                // Duration
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
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
          SizedBox(height: 8.h),

          // Video info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 12, color: Colors.grey[600]),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "${video.totalViews.toShortScale.toArabicNumbers(context)} views • ${timeago.format(video.createdAt ?? DateTime.now(), locale: context.locale.languageCode).toArabicNumbers(context)}",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: List.generate(5, (starIndex) => 
                        Icon(
                          starIndex < video.averageRating ? Icons.star : Icons.star_outline,
                          size: 12,
                          color: starIndex < video.averageRating ? Colors.amber : Colors.grey[400],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showVideoOptions(video),
                child: Icon(
                  Icons.more_vert,
                  size: 16,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVideosList(List<StarEntity> videos) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return _buildVideoListItem(video);
      },
    );
  }

  Widget _buildVideoListItem(StarEntity video) {
    return GestureDetector(
      onTap: () {
        // Navigate to video player
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              width: 120.w,
              height: 68.h,
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
                  // Volume icon
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.volume_off,
                        color: Colors.white,
                        size: 12,
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
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        '7:54',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
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
                    video.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "RAV",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "${video.totalViews.toShortScale.toArabicNumbers(context)} Views • ${timeago.format(video.createdAt ?? DateTime.now(), locale: context.locale.languageCode).toArabicNumbers(context)}",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // More options
            GestureDetector(
              onTap: () => _showVideoOptions(video),
              child: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Icon(
                  Icons.more_vert,
                  size: 20,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistCard(PlaylistEntity playlist) {
    return GestureDetector(
      onTap: () {
        // Navigate to playlist view
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Playlist thumbnail stack
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.grey[300],
              ),
              child: Stack(
                children: [
                  // Main thumbnail
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      image: DecorationImage(
                        image: AssetImage('assets/images/testforvideo.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Playlist indicator
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.playlist_play,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(width: 2),
                          Text(
                            '${playlist.videos.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // Playlist info
          Text(
            playlist.name,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Text(
            "Heart Touching • Playlist",
            style: TextStyle(
              fontSize: 11.sp,
              color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
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
              leading: Icon(Icons.share, color: context.isDarkMode ? Colors.white : Colors.black),
              title: Text('Share', style: TextStyle(color: context.isDarkMode ? Colors.white : Colors.black)),
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

  void _showVideoOptions(StarEntity video) {
    // Implement video options similar to TalentCard
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
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
          unselectedLabelColor: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
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