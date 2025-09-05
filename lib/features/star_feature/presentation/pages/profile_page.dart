import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/user_star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/playlist_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/common/error_widget.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/common/loading_indicator.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../controller/profile_cubit/profile_cubit.dart';
import '../widgets/profile_components/edit_profile_sheet.dart';
import '../widgets/profile_components/profile_app_bar.dart';
import '../widgets/profile_components/profile_header.dart';
import '../widgets/profile_components/profile_tab_bar.dart';
import '../widgets/profile_components/profile_tabs_content.dart';

class ProfilePageView extends StatefulWidget {
  final UserStarEntity? user;
  final List<StarEntity> userVideos;
  final bool isCurrentUser;
  final String? profileId;

  const ProfilePageView({
    super.key,
    this.user,
    required this.userVideos,
    this.isCurrentUser = true,
    this.profileId,
  });

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late ProfileCubit _profileCubit;
  late ScrollController _scrollController;

  // Extended data for better UX
  late List<StarEntity> _extendedVideos;
  late List<PlaylistEntity> _mockPlaylists;

  bool _isAppBarExpanded = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeData();
    _loadProfileIfNeeded();
  }

  void _initializeControllers() {
    _tabController = TabController(length: 3, vsync: this);
    _profileCubit = context.read<ProfileCubit>();
    _scrollController = ScrollController();

    // Listen to scroll to handle app bar animation
    _scrollController.addListener(_handleScroll);
  }

  void _initializeData() {
    _extendedVideos = _createExtendedVideoList();
    _mockPlaylists = _createMockPlaylists();
  }

  void _loadProfileIfNeeded() {
    if (widget.isCurrentUser && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_profileCubit.isClosed) {
          _profileCubit.getMyProfile();
        }
      });
    } else if (widget.profileId != null && mounted) {
      // Load profile by ID for other users
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_profileCubit.isClosed) {
          _profileCubit.getProfileById(widget.profileId!);
        }
      });
    }
  }

  void _handleScroll() {
    const expandedHeight = 200.0;
    final isExpanded = _scrollController.hasClients &&
        _scrollController.offset < expandedHeight;

    if (_isAppBarExpanded != isExpanded) {
      setState(() => _isAppBarExpanded = isExpanded);
    }
  }

  List<StarEntity> _createExtendedVideoList() {
    if (widget.userVideos.isEmpty) return [];

    final List<StarEntity> extendedVideos = [];

    // Extend videos for better scrolling experience
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < widget.userVideos.length; j++) {
        final originalVideo = widget.userVideos[j];
        extendedVideos.add(originalVideo.copyWith(
          id: '${originalVideo.id}_$i$j',
          totalViews: originalVideo.totalViews + (i * 1000),
          createdAt: DateTime.now().subtract(Duration(days: i + j)),
        ));
      }
    }

    return extendedVideos;
  }

  List<PlaylistEntity> _createMockPlaylists() {
    return [
      PlaylistEntity(
        id: '1',
        name: 'Heart Touching - Playlist',
        description: 'Beautiful collection of heart touching nasheeds',
        videos: _extendedVideos.take(25).toList(),
        thumbnailUrl: 'assets/images/testforvideo.jpg',
        createdAt: DateTime.now().subtract(Duration(days: 30)),
      ),
      PlaylistEntity(
        id: '2',
        name: 'Spiritual Journey - Playlist',
        description: 'Another beautiful collection for spiritual growth',
        videos: _extendedVideos.skip(10).take(30).toList(),
        thumbnailUrl: 'assets/images/testforvideo.jpg',
        createdAt: DateTime.now().subtract(Duration(days: 60)),
      ),
    ];
  }

  void _showEditProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: _profileCubit,
        child: EditProfileSheet(
          currentProfile: _profileCubit.state.profile,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, profileState) {
          return _buildContent(profileState);
        },
      ),
    );
  }

  Widget _buildContent(ProfileState profileState) {
    debugPrint('Profile State: ${profileState.status}');
    debugPrint('Has Profile: ${profileState.hasProfile}');

    if (profileState.isLoading && !profileState.hasProfile) {
      return const Center(
        child: StarLoadingIndicator(message: 'Loading profile...'),
      );
    }

    if (profileState.isError && !profileState.hasProfile) {
      return Center(
        child: StarErrorWidget(
          message: profileState.failure?.toString() ?? 'Failed to load profile',
          onRetry: () => _profileCubit.getMyProfile(),
        ),
      );
    }

    return Column(
      children: [
        ProfileAppBar(
          isCurrentUser: widget.isCurrentUser,
          onEditPressed: _showEditProfileSheet,
          onBackPressed: () {
            ManageVibration.vibrate();
            Navigator.pop(context);
          },
          user: widget.user,
        ),
        Expanded(
          child: SafeArea(
            top: false,
            child: NestedScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(), // إضافة physics
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: ProfileHeader(
                      profile:
                          widget.isCurrentUser ? profileState.profile : null,
                      user: widget.user,
                      isCurrentUser: widget.isCurrentUser,
                      videosCount: _getVideosCount(profileState),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    floating: false, // إضافة floating
                    delegate: _SliverTabBarDelegate(
                      ProfileTabBar(tabController: _tabController),
                    ),
                  ),
                ];
              },
              body: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ProfileTabsContent(
                  tabController: _tabController,
                  extendedVideos: _extendedVideos,
                  playlists: _mockPlaylists,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  int _getVideosCount(ProfileState profileState) {
    if (widget.isCurrentUser && profileState.profile != null) {
      return profileState.profile!.videosCount;
    }
    return widget.userVideos.length;
  }
}

// Custom SliverPersistentHeaderDelegate for TabBar
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final ProfileTabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => 56.0; // تغيير من 50 إلى 56

  @override
  double get maxExtent => 56.0; // تغيير من 50 إلى 56

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 56.0, // إضافة height صريح
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
