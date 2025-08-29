import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart' as easy_localization;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/user_star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/profile_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/helper/youtube_style_video_player.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/edit_profile_bottom_sheet.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/talent_card_widget.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/profile_video_cards.dart';
import 'package:fourtyninehub/features/star_feature/presentation/helper/talent_video_player.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../helpers/manage_vibration.dart';

class ProfilePageView extends StatefulWidget {
  final UserStarEntity? user; // Make optional for current user
  final List<StarEntity> userVideos;
  final bool isCurrentUser; // Flag to determine if it's current user's profile

  const ProfilePageView({
    super.key,
    this.user,
    required this.userVideos,
    this.isCurrentUser = true,
  });

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ProfileCubit _profileCubit;
  final bool _isSubscribed = false;

  // Mock playlists data
  late List<PlaylistEntity> _mockPlaylists;
  late List<StarEntity> _extendedUserVideos;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _profileCubit =
        context.read<ProfileCubit>(); // This line is already correct
    _initializeMockPlaylists();

    // Load profile data if it's current user
    if (widget.isCurrentUser) {
      _profileCubit.getMyProfile();
    }
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
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, profileState) {
          return Column(
            children: [
              // Fixed App Bar
              _buildAppBar(),

              // Profile Header
              _buildProfileHeader(profileState),

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
          );
        },
      ),
    );
  }

  void _showEditProfileBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: _profileCubit,
        child: EditProfileBottomSheet(
          currentProfile: _profileCubit.state.profile,
        ),
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
              onPressed: () {
                ManageVibration.vibrate();
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Text(
                widget.isCurrentUser
                    ? (context.isArabic ? 'ملفي الشخصي' : 'My Profile')
                    : 'Winners 🏆',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: _getResponsiveFontSize(20),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Edit button for current user - Updated to use bottom sheet
            if (widget.isCurrentUser) ...[
              IconButton(
                icon: Icon(Icons.edit, color: Colors.black, size: 24),
                onPressed: () {
                  ManageVibration.vibrate();
                  _showEditProfileBottomSheet();
                }, // Changed this line
              ),
            ] else ...[
              SizedBox(width: 48.w),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileState profileState) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: _getResponsivePadding(20),
        // vertical: _getResponsivePadding(10),
      ),
      child: Column(
        children: [
          // Banner Section
          _buildBannerSection(profileState),
          SizedBox(height: _getResponsiveSpacing(20)),

          // Profile Info Section
          _buildProfileInfoSection(profileState),
        ],
      ),
    );
  }

  Widget _buildBannerSection(ProfileState profileState) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth * 0.3;

    // Use profile data if current user and available
    final bannerUrl =
        widget.isCurrentUser && profileState.profile?.channelCover != null
            ? profileState.profile!.channelCover!.mediaKey
            : null;

    return Container(
      width: double.infinity,
      height: bannerHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_getResponsiveBorderRadius(16)),
      ),
      child: bannerUrl != null
          ? ClipRRect(
              borderRadius:
                  BorderRadius.circular(_getResponsiveBorderRadius(16)),
              child: Image.network(
                bannerUrl,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/testforvideo.jpg',
                    fit: BoxFit.cover,
                  );
                },
                fit: BoxFit.cover,
              ),
            )
          : null,
    );
  }

  Widget _buildProfileInfoSection(ProfileState profileState) {
    final screenWidth = MediaQuery.of(context).size.width;
    final profileSize = screenWidth < 360 ? 60.0 : 80.0;

    // Use profile data if available
    final profileImageUrl =
        widget.isCurrentUser && profileState.profile?.channelPicture != null
            ? profileState.profile!.channelPicture!.mediaKey
            : widget.user?.image;

    final displayName = widget.isCurrentUser && profileState.profile != null
        ? profileState.profile!.channelName
        : (widget.user != null ? widget.user!.firstName : "Unknown User");

    final videosCount = widget.isCurrentUser && profileState.profile != null
        ? profileState.profile!.videosCount
        : widget.userVideos.length;

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
                child: profileImageUrl != null && profileImageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: profileImageUrl,
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
                    displayName,
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(24),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: _getResponsiveSpacing(4)),
                  Directionality(
                    textDirection: context.isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Text(
                      context.isArabic
                          ? "${displayName.toLowerCase().replaceAll(' ', '')}@ • ${_getArabicVideosText(videosCount)}"
                          : "@${displayName.toLowerCase().replaceAll(' ', '')} • $videosCount videos",
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(16),
                        color: Colors.grey[600],
                        fontFamily: context.isArabic ? 'NotoSansArabic' : null,
                      ),
                      textAlign:
                          context.isArabic ? TextAlign.right : TextAlign.left,
                      textDirection: context.isArabic
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                  ),
                  if (widget.isCurrentUser &&
                      profileState.profile?.channelDescription.isNotEmpty ==
                          true) ...[
                    SizedBox(height: _getResponsiveSpacing(8)),
                    Text(
                      profileState.profile!.channelDescription,
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(14),
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
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
          Tab(text: context.isArabic ? 'الرئيسية' : 'Home'),
          Tab(text: context.isArabic ? 'الفيديوهات' : 'Videos'),
          Tab(text: context.isArabic ? 'قوائم التشغيل' : 'Playlists'),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // For You Section - Horizontal Scroll
          Padding(
            padding: EdgeInsets.only(
                left: _getResponsivePadding(20),
                right: _getResponsivePadding(20),
                top: _getResponsivePadding(20),
                bottom: _getResponsivePadding(16)),
            child: Text(
              context.isArabic ? 'لك' : 'For You',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(22),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Horizontal scrollable For You section
          SizedBox(
            height: _getVideoCardHeight(),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: _getResponsivePadding(20)),
              itemCount: _extendedUserVideos.length,
              itemBuilder: (context, index) {
                final video = _extendedUserVideos[index];
                return Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.only(right: _getResponsiveSpacing(12)),
                  child: _buildVideoCard(video, index),
                );
              },
            ),
          ),

          // New Song 2020 Section - Vertical Scroll
          Padding(
            padding: EdgeInsets.only(
              left: _getResponsivePadding(20),
              right: _getResponsivePadding(20),
              bottom: _getResponsivePadding(16),
            ),
            child: Text(
              context.isArabic ? 'أغنية جديدة 2020' : 'New Song 2020',
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
    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        _navigateToVideo(video);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with overlay elements
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(_getResponsiveBorderRadius(12)),
                color: Colors.grey[300],
                border: Border.all(color: Colors.grey[300]!, width: 1.5),
                image: DecorationImage(
                  image: AssetImage('assets/images/testforvideo.jpg'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Heart icon - top left
                  Positioned(
                    top: _getResponsiveSpacing(10),
                    left: _getResponsiveSpacing(10),
                    child: Container(
                      padding: EdgeInsets.all(_getResponsiveSpacing(6)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: _getResponsiveIconSize(16),
                      ),
                    ),
                  ),
                  // Volume icon - top right
                  Positioned(
                    top: _getResponsiveSpacing(10),
                    right: _getResponsiveSpacing(10),
                    child: Container(
                      padding: EdgeInsets.all(_getResponsiveSpacing(6)),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.volume_up,
                        color: Colors.white,
                        size: _getResponsiveIconSize(14),
                      ),
                    ),
                  ),
                  // Duration - bottom right
                  Positioned(
                    bottom: _getResponsiveSpacing(10),
                    right: _getResponsiveSpacing(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: _getResponsiveSpacing(8),
                        vertical: _getResponsiveSpacing(4),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(
                            _getResponsiveBorderRadius(6)),
                      ),
                      child: Text(
                        '7:54',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _getResponsiveFontSize(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: _getResponsiveSpacing(12)),

          // Video info with profile pic
          Container(
            padding: EdgeInsets.symmetric(horizontal: _getResponsiveSpacing(4)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture
                GestureDetector(
                  onTap: () {
                    ManageVibration.vibrate();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.isDarkMode
                            ? Colors.grey[700]!
                            : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20, // حجم أصغر
                      backgroundColor: Colors.grey[300],
                      backgroundImage: video.user.image.isNotEmpty
                          ? NetworkImage(video.user.image)
                          : null,
                      child: video.user.image.isEmpty
                          ? Icon(
                              Icons.person,
                              size: _getResponsiveIconSize(14),
                              color: Colors.grey[600],
                            )
                          : null,
                    ),
                  ),
                ),

                SizedBox(width: _getResponsiveSpacing(12)),

                // Title and Info - تحسين التخطيط
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ManageVibration.vibrate();
                      if (!widget.isCurrentUser) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePageView(
                              user: video.user,
                              userVideos: widget.userVideos,
                              isCurrentUser: false,
                            ),
                          ),
                        );
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // العنوان
                        Text(
                          video.title,
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(15),
                            fontWeight: FontWeight.w600,
                            color: context.isDarkMode
                                ? Colors.white
                                : Colors.black87,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: _getResponsiveSpacing(6)),

                        // اسم المستخدم
                        Text(
                          "${video.user.firstName} ${video.user.lastName}",
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(13),
                            fontWeight: FontWeight.w500,
                            color: context.isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: _getResponsiveSpacing(4)),

                        // المشاهدات والتاريخ
                        Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              size: _getResponsiveIconSize(14),
                              color: context.isDarkMode
                                  ? Colors.grey[500]
                                  : Colors.grey[600],
                            ),
                            SizedBox(width: _getResponsiveSpacing(4)),
                            Expanded(
                              child: Text(
                                "${video.totalViews.toShortScale.toArabicNumbers(context)} ${LocaleKeys.views.localize} • ${timeago.format(video.createdAt ?? DateTime.now(), locale: context.locale.languageCode)}",
                                style: TextStyle(
                                  fontSize: _getResponsiveFontSize(12),
                                  color: context.isDarkMode
                                      ? Colors.grey[500]
                                      : Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: _getResponsiveSpacing(8)),

                // More Options and Stars
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // زر الخيارات
                    Container(
                      padding: EdgeInsets.all(2),
                      child: IconButton(
                        onPressed: () {
                          ManageVibration.vibrate();
                           showYouTubeOptions(context);},
                        icon: Icon(
                          Icons.more_vert,
                          color: context.isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[600],
                          size: _getResponsiveIconSize(22),
                        ),
                        padding: EdgeInsets.all(4),
                        constraints: BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ),

                    SizedBox(height: _getResponsiveSpacing(4)),

                    // النجوم
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          5,
                          (starIndex) => GestureDetector(
                            onTap: () {
                              ManageVibration.vibrate();
                              context
                                  .read<StarCubit>()
                                  .updateRating(video.id, starIndex + 1);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: _getResponsiveSpacing(1),
                              ),
                              child: Icon(
                                starIndex < video.averageRating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: starIndex < video.averageRating
                                    ? Colors.amber[600]
                                    : (context.isDarkMode
                                        ? Colors.grey[600]
                                        : Colors.grey[400]),
                                size: _getResponsiveIconSize(18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // إضافة مسافة في النهاية
          SizedBox(height: _getResponsiveSpacing(8)),
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
            ManageVibration.vibrate();
            Navigator.pop(context);
            // Handle play next
          },
        ),
        OptionItem(
          icon: Icons.block,
          title: context.isArabic ? 'غير مهتم' : 'Not interested',
          onTap: () {
            ManageVibration.vibrate();
            Navigator.pop(context);
            // Handle not interested
          },
        ),
        OptionItem(
          icon: Icons.visibility_off,
          title: context.isArabic ? 'اخفاء' : 'Hide',
          onTap: () {
            ManageVibration.vibrate();
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
            ManageVibration.vibrate();
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
            ManageVibration.vibrate();
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(width * 0.1),
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
          onTap: () {
            ManageVibration.vibrate();
            _navigateToPlaylist(playlist);
          },
        );
      },
    );
  }

  Widget _buildListVideoItem(StarEntity video, int index) {
    final thumbnailWidth = MediaQuery.of(context).size.width * 0.4;
    final thumbnailHeight = thumbnailWidth * 0.56;

    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        _navigateToVideo(video);
      },
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
                    video.title,
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
                    "${video.user.firstName} ${video.user.lastName}",
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(14),
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: _getResponsiveSpacing(4)),
                  Text(
                    "${video.totalViews.toShortScale.toArabicNumbers(context)} ${LocaleKeys.views.localize} • ${timeago.format(video.createdAt ?? DateTime.now(), locale: context.locale.languageCode)}",
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
              onTap: () {
                ManageVibration.vibrate();
                _showMoreOptions(context, video);
              },
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

  // Helper methods for responsive design
  double _getResponsiveFontSize(double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseFontSize * 0.85;
    } else if (screenWidth > 400) {
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }

  double _getResponsivePadding(double basePadding) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return basePadding * 0.8;
    } else if (screenWidth > 400) {
      return basePadding * 1.15;
    }
    return basePadding;
  }

  double _getResponsiveSpacing(double baseSpacing) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSpacing * 0.75;
    }
    return baseSpacing;
  }

  double _getResponsiveIconSize(double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSize * 0.9;
    }
    return baseSize;
  }

  double _getResponsiveBorderRadius(double baseRadius) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseRadius * 0.8;
    }
    return baseRadius;
  }

  double _getVideoCardHeight() {
    final cardWidth = MediaQuery.of(context).size.width * 0.5;
    return cardWidth * 1.55;
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
    // Handle playlist navigation
    print('Navigate to playlist: ${playlist.name}');
  }

  void _showMoreOptions(BuildContext context, StarEntity video) {
    TalentCard.showYouTubeOptions(context, video);
  }

  String _getArabicVideosText(int count) {
    if (count == 0) {
      return 'لا توجد فيديوهات';
    } else if (count == 1) {
      return 'فيديو واحد';
    } else if (count == 2) {
      return 'فيديوهان';
    } else if (count >= 3 && count <= 10) {
      return '$count فيديوهات';
    } else {
      return '$count فيديو';
    }
  }
}
