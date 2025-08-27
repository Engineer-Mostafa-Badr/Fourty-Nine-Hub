import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/user_star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/helper/youtube_style_video_player.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/talent_card_widget.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/profile_video_cards.dart';
import 'package:fourtyninehub/features/star_feature/presentation/helper/talent_video_player.dart';
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
  final bool _isSubscribed = false;

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
          title: originalVideo.title,
          description: originalVideo.description,
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
      body: Column(
        children: [
          // Fixed App Bar
          _buildAppBar(),

          // Profile Header
          _buildProfileHeader(),

          // Tab Bar
          _buildTabBar(),

          // Tab Content
          Expanded(
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

  Widget _buildAppBar() {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: MediaQuery.of(context).size.width < 360 ? 20 : 24,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Text(
                'Winners 🏆',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: _getResponsiveFontSize(20),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 48.w), // Balance the back button
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        indicatorColor: Colors.black,
        indicatorWeight: 3,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: TextStyle(
          fontSize: _getResponsiveFontSize(18),
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: _getResponsiveFontSize(18),
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

  Widget _buildProfileHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: _getResponsivePadding(20),
        vertical: _getResponsivePadding(16),
      ),
      child: Column(
        children: [
          // Banner Section
          _buildBannerSection(),
          SizedBox(height: _getResponsiveSpacing(20)),

          // Profile Info Section
          _buildProfileInfoSection(),
        ],
      ),
    );
  }

  Widget _buildBannerSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth * 0.4; // 40% of screen width

    return Container(
      width: double.infinity,
      height: bannerHeight.clamp(120.0, 200.0), // Min 120, Max 200
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_getResponsiveBorderRadius(16)),
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
          // Decorative buildings/shapes - responsive positioning
          Positioned(
            bottom: 0,
            left: screenWidth * 0.1, // 10% from left
            child: _buildBuilding(
              screenWidth * 0.12, // 12% of screen width
              bannerHeight * 0.5, // 50% of banner height
              Colors.black87,
            ),
          ),
          Positioned(
            bottom: 0,
            left: screenWidth * 0.4, // 40% from left (center-ish)
            child: _buildBuilding(
              screenWidth * 0.15, // 15% of screen width
              bannerHeight * 0.6, // 60% of banner height
              Colors.black87,
            ),
          ),
          Positioned(
            bottom: 0,
            right: screenWidth * 0.15, // 15% from right
            child: _buildBuilding(
              screenWidth * 0.13, // 13% of screen width
              bannerHeight * 0.52, // 52% of banner height
              Colors.black87,
            ),
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
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
      child: Column(
        children: [
          // Building windows pattern - responsive
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(width * 0.1), // 10% of building width
              child: Wrap(
                spacing: 3,
                runSpacing: 3,
                children: List.generate(
                  ((width / 15) * (height / 15)).round().clamp(4, 16),
                  (index) => Container(
                    width: (width * 0.15).clamp(6.0, 12.0),
                    height: (width * 0.15).clamp(6.0, 12.0),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final profileSize = screenWidth < 360 ? 60.0 : 80.0;

    return Column(
      children: [
        Row(
          children: [
            // Profile Picture - responsive size
            Container(
              width: profileSize,
              height: profileSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[300]!,
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
                          child: Icon(Icons.person,
                              size: profileSize * 0.5, color: Colors.grey[600]),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.person,
                              size: profileSize * 0.5, color: Colors.grey[600]),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.person,
                            size: profileSize * 0.5, color: Colors.grey[600]),
                      ),
              ),
            ),
            SizedBox(width: _getResponsiveSpacing(16)),

            // Name and Stats
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Heart Touching",
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(24),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: _getResponsiveSpacing(4)),
                  Text(
                    "@heart • ${widget.userVideos.length} videos",
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(16),
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
      padding: EdgeInsets.only(bottom: _getResponsivePadding(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // For You Section - Horizontal Scroll
          Padding(
            padding: EdgeInsets.only(
                left: _getResponsivePadding(20),
                top: _getResponsivePadding(20),
                bottom: _getResponsivePadding(16)),
            child: Text(
              'For You',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(22),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Horizontal scrollable For You section - responsive height
          SizedBox(
            height: _getVideoCardHeight(),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: _getResponsivePadding(20)),
              itemCount: _extendedUserVideos.length,
              itemBuilder: (context, index) {
                final video = _extendedUserVideos[index];
                return Container(
                  // width: _getVideoCardWidth(),
                  width: MediaQuery.of(context).size.width * 0.6,
                  margin: EdgeInsets.only(right: _getResponsiveSpacing(12)),
                  child: _buildVideoCard(video, index),
                );
              },
            ),
          ),

          SizedBox(height: _getResponsiveSpacing(32)),

          // New Song 2020 Section - Vertical Scroll
          Padding(
            padding: EdgeInsets.only(
                left: _getResponsivePadding(20),
                bottom: _getResponsivePadding(16)),
            child: Text(
              'New Song 2020',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(22),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Vertical scrollable New Song section
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: 8,
            itemBuilder: (context, index) {
              final video =
                  _extendedUserVideos[index % _extendedUserVideos.length];
              return Padding(
                padding: EdgeInsets.only(bottom: _getResponsiveSpacing(16)),
                child: _buildListVideoItem(video, index),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(StarEntity video, int index) {
    // final thumbnailHeight = _getVideoCardWidth() * 0.8; // Maintain aspect ratio

    return GestureDetector(
      onTap: () => _navigateToVideo(video),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with overlay elements
          Container(
            // height: thumbnailHeight,
            height: MediaQuery.of(context).size.width * 0.35,
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(_getResponsiveBorderRadius(10)),
              color: Colors.grey[300],
              border: Border.all(color: Colors.grey[300]!, width: 2),
              image: DecorationImage(
                image: AssetImage('assets/images/testforvideo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Heart icon - top left
                Positioned(
                  top: _getResponsiveSpacing(8),
                  left: _getResponsiveSpacing(8),
                  child: Container(
                    padding: EdgeInsets.all(_getResponsiveSpacing(6)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: _getResponsiveIconSize(18),
                    ),
                  ),
                ),
                // Volume icon - top right
                Positioned(
                  top: _getResponsiveSpacing(8),
                  right: _getResponsiveSpacing(8),
                  child: Container(
                    padding: EdgeInsets.all(_getResponsiveSpacing(6)),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: _getResponsiveIconSize(16),
                    ),
                  ),
                ),
                // Duration - bottom right
                Positioned(
                  bottom: _getResponsiveSpacing(8),
                  right: _getResponsiveSpacing(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: _getResponsiveSpacing(8),
                        vertical: _getResponsiveSpacing(4)),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius:
                          BorderRadius.circular(_getResponsiveBorderRadius(6)),
                    ),
                    child: Text(
                      '7:54',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _getResponsiveFontSize(12),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: _getResponsiveSpacing(12)),

          // Video info with profile pic
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     CircleAvatar(
          //       radius: _getResponsiveIconSize(16),
          //       backgroundColor: Colors.grey[300],
          // backgroundImage: video.user.image.isNotEmpty
          //     ? NetworkImage(video.user.image)
          //     : null,
          //       child: video.user.image.isEmpty
          //           ? Icon(Icons.person,
          //               size: _getResponsiveIconSize(16),
          //               color: Colors.grey[600])
          //           : null,
          //     ),
          //     SizedBox(width: _getResponsiveSpacing(8)),
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             "Heart Touching Nasheed",
          //             style: TextStyle(
          //               fontSize: _getResponsiveFontSize(13),
          //               fontWeight: FontWeight.w600,
          //               color: Colors.black,
          //             ),
          //             maxLines: 2,
          //             overflow: TextOverflow.ellipsis,
          //           ),
          //           SizedBox(height: _getResponsiveSpacing(3)),
          //           Text(
          //             "507K views • 10 months ago",
          //             style: TextStyle(
          //               fontSize: _getResponsiveFontSize(11),
          //               color: Colors.grey[600],
          //             ),
          //             maxLines: 1,
          //             overflow: TextOverflow.ellipsis,
          //           ),
          //           SizedBox(height: _getResponsiveSpacing(4)),
          //           // Star rating
          //           Row(
          //             mainAxisSize: MainAxisSize.min,
          //             children: List.generate(
          //               5,
          //               (starIndex) => Icon(
          //                 starIndex < 3 ? Icons.star : Icons.star_border,
          //                 size: _getResponsiveIconSize(12),
          //                 color:
          //                     starIndex < 3 ? Colors.amber : Colors.grey[400],
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     SizedBox(width: _getResponsiveSpacing(4)),
          //     GestureDetector(
          //       onTap: () => _showMoreOptions(context, video),
          //       child: Padding(
          //         padding: EdgeInsets.all(_getResponsiveSpacing(4)),
          //         child: Icon(
          //           Icons.more_vert,
          //           size: _getResponsiveIconSize(18),
          //           color: Colors.grey[700],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: video.user.image.isNotEmpty
                      ? NetworkImage(video.user.image)
                      : null,
                  child: video.user.image.isEmpty
                      ? Icon(Icons.person,
                          size: _getResponsiveIconSize(16),
                          color: Colors.grey[600])
                      : null,
                ),
              ),
              SizedBox(width: 12),

              // Title and Info
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePageView(
                          user: widget.user,
                          userVideos: widget.userVideos,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "test",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color:
                              context.isDarkMode ? Colors.white : Colors.black,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Mohamed Ahmed",
                        style: TextStyle(
                          fontSize: 13,
                          color: context.isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 14,
                            color: context.isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Text(
                            "47K ${LocaleKeys.views.localize} • 2 years ago",
                            style: TextStyle(
                              fontSize: 13,
                              color: context.isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // More Options and Stars
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => showYouTubeOptions(context),
                    icon: Icon(
                      Icons.more_vert,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                      size: 25,
                    ),
                    padding: EdgeInsets.all(4),
                    constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (starIndex) => GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1),
                          child: Icon(
                            starIndex < starIndex + 1
                                ? Icons.star
                                : Icons.star_border,
                            color: starIndex < starIndex + 1
                                ? Colors.amber
                                : Colors.grey[400],
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  void showYouTubeOptions(BuildContext context) {
    final cubit = context.read<StarCubit>();
    OptionsBottomSheet.showOptions(
      context: context,
      options: [
        OptionItem(
          icon: Icons.playlist_add,
          title: context.isArabic ? 'انشاء قائمة' : 'Play next in queue',
          onTap: () {
            Navigator.pop(context);
            // Handle play next
          },
        ),
        OptionItem(
          icon: Icons.block,
          title: context.isArabic ? 'غير مهتم' : 'Not interested',
          onTap: () {
            Navigator.pop(context);
            // Handle not interested
          },
        ),
        OptionItem(
          icon: Icons.visibility_off,
          title: context.isArabic ? 'اخفاء' : 'Hide',
          onTap: () {
            Navigator.pop(context);
            // Handle hide
          },
        ),
        OptionItem(
          icon: cubit.isFavorite("1") ? Icons.favorite : Icons.favorite_border,
          title: cubit.isFavorite("1")
              ? (context.isArabic
                  ? 'ازالة من المفضلة'
                  : 'Remove from favorites')
              : (context.isArabic ? 'اضافة للمفضلة' : 'Add to favorites'),
          onTap: () {
            Navigator.pop(context);
            cubit.toggleFavorite("1");
          },
        ),
        OptionItem(
          icon: Icons.flag,
          title: context.isArabic ? 'ابلاغ' : 'Report',
          iconColor: Colors.red,
          textColor: Colors.red,
          onTap: () {
            Navigator.pop(context);
            bottomSheet(
              context: context,
              widget: ReportView(
                id: "1",
                categoryId: "67e952dbbb085740a35d4281",
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildListVideoItem(StarEntity video, int index) {
    final thumbnailWidth =
        MediaQuery.of(context).size.width * 0.4; // 40% of screen width
    final thumbnailHeight = thumbnailWidth * 0.56; // 16:9 aspect ratio

    return GestureDetector(
      onTap: () => _navigateToVideo(video),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _getResponsivePadding(20),
            vertical: _getResponsivePadding(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              width: thumbnailWidth,
              height: thumbnailHeight,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(_getResponsiveBorderRadius(10)),
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
                    top: _getResponsiveSpacing(8),
                    left: _getResponsiveSpacing(8),
                    child: Container(
                      padding: EdgeInsets.all(_getResponsiveSpacing(6)),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(
                            _getResponsiveBorderRadius(6)),
                      ),
                      child: Icon(
                        Icons.volume_up,
                        color: Colors.white,
                        size: _getResponsiveIconSize(16),
                      ),
                    ),
                  ),
                  // Duration
                  Positioned(
                    bottom: _getResponsiveSpacing(8),
                    right: _getResponsiveSpacing(8),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: _getResponsiveSpacing(6),
                          vertical: _getResponsiveSpacing(3)),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(
                            _getResponsiveBorderRadius(4)),
                      ),
                      child: Text(
                        '7:54',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _getResponsiveFontSize(11),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: _getResponsiveSpacing(16)),

            // Video info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Heart Touching Nasheed",
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(16),
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: _getResponsiveSpacing(6)),
                  Text(
                    "RAV",
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(14),
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: _getResponsiveSpacing(4)),
                  Text(
                    "507K Views • 10 Months Ago",
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(13),
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
                padding: EdgeInsets.only(top: _getResponsiveSpacing(8)),
                child: Icon(
                  Icons.more_vert,
                  size: _getResponsiveIconSize(20),
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
      padding: EdgeInsets.symmetric(vertical: _getResponsivePadding(12)),
      itemCount: _extendedUserVideos.length,
      itemBuilder: (context, index) {
        final video = _extendedUserVideos[index];
        return Padding(
          padding: EdgeInsets.only(bottom: _getResponsiveSpacing(16)),
          child: _buildListVideoItem(video, index),
        );
      },
    );
  }

  Widget _buildPlaylistsTab() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: _getResponsivePadding(12)),
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

  // Helper methods for responsive design
  double _getResponsiveFontSize(double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseFontSize * 0.85; // 15% smaller for small screens
    } else if (screenWidth > 400) {
      return baseFontSize * 1.1; // 10% larger for bigger screens
    }
    return baseFontSize;
  }

  double _getResponsivePadding(double basePadding) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return basePadding * 0.8; // 20% smaller padding
    } else if (screenWidth > 400) {
      return basePadding * 1.15; // 15% larger padding
    }
    return basePadding;
  }

  double _getResponsiveSpacing(double baseSpacing) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSpacing * 0.75; // 25% smaller spacing
    }
    return baseSpacing;
  }

  double _getResponsiveIconSize(double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSize * 0.9; // 10% smaller icons
    }
    return baseSize;
  }

  double _getResponsiveBorderRadius(double baseRadius) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseRadius * 0.8; // 20% smaller border radius
    }
    return baseRadius;
  }

  double _getVideoCardWidth() {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return screenWidth * 0.42; // 42% of screen width for small screens
    } else if (screenWidth > 400) {
      return screenWidth * 0.38; // 38% for larger screens
    }
    return screenWidth * 0.4; // 40% for medium screens
  }

  double _getVideoCardHeight() {
    final cardWidth = _getVideoCardWidth();
    return cardWidth * 1.55; // Maintain aspect ratio for the entire card
  }

  void _navigateToVideo(StarEntity video) {
    final mediaUrl =
        video.mediaUrl.isNotEmpty ? video.mediaUrl.first.mediaKey : '';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TalentVideoPlayer(
          videoUrl: mediaUrl,
          talent: video,
        ),
      ),
    );
  }

  void _navigateToPlaylist(PlaylistEntity playlist) {
    print('Navigate to playlist: ${playlist.name}');
  }

  void _showMoreOptions(BuildContext context, StarEntity video) {
    TalentCard.showYouTubeOptions(context, video);
  }
}
