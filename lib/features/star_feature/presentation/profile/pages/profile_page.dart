import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/user_star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/shared/widgets/common/error_widget.dart';
import 'package:fourtyninehub/features/star_feature/presentation/shared/widgets/common/loading_indicator.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../presentation_exports.dart';
import '../widgets/edit_profile_sheet.dart';

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
  late StarCubit _starCubit;
  late ScrollController _scrollController;

  List<StarEntity> _userRealVideos = [];
  bool _isLoadingUserVideos = false;

  bool _isAppBarExpanded = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadProfileAndVideos();
  }

  void _initializeControllers() {
    // Set tab length based on user type: 4 for current user, 3 for others
    final tabLength = widget.isCurrentUser ? 4 : 3;
    _tabController = TabController(length: tabLength, vsync: this);
    _profileCubit = context.read<ProfileCubit>();
    _starCubit = context.read<StarCubit>();
    _scrollController = ScrollController();

    // Listen to scroll to handle app bar animation
    _scrollController.addListener(_handleScroll);

    print(
        '🔧 TabController initialized with length: $tabLength for isCurrentUser: ${widget.isCurrentUser}');
  }

  void _loadProfileAndVideos() async {
    // Load profile data
    if (widget.isCurrentUser && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_profileCubit.isClosed) {
          _profileCubit.getMyProfile();
        }
      });
    } else if (widget.profileId != null && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_profileCubit.isClosed) {
          _profileCubit.getProfileById(widget.profileId!);
        }
      });
    }

    // Load user's actual videos
    await _loadUserActualVideos();
  }

  Future<void> _loadUserActualVideos() async {
    print("🎥 Starting to load user actual videos");
    print("👤 Is current user: ${widget.isCurrentUser}");
    print("📦 Widget fallback videos: ${widget.userVideos.length}");

    setState(() {
      _isLoadingUserVideos = true;
    });

    try {
      if (widget.isCurrentUser) {
        // For current user, load their videos from myTalents
        print("🎬 Loading current user's myTalents");
        await _starCubit.loadTalents(TalentCategory.myTalents, refresh: true);

        final myTalents = _starCubit.state.myTalents;
        print("✅ Loaded myTalents: ${myTalents.length}");

        setState(() {
          _userRealVideos = myTalents;
        });
      } else {
        print("👥 Loading other user's videos");

        // First, ensure available videos are loaded
        if (_starCubit.state.availableTalents.isEmpty) {
          print("🔄 Loading available videos first...");
          await _starCubit.loadTalents(TalentCategory.available, refresh: true);
        }

        // Filter videos that belong to this specific user from available videos
        final availableVideos = _starCubit.state.availableTalents;
        print("📺 Available videos in cubit: ${availableVideos.length}");

        final filteredVideos = availableVideos
            .where((video) => video.user.id == widget.user?.id)
            .toList();
        print(
            "🔍 Filtered videos for user ${widget.user?.id}: ${filteredVideos.length}");

        // Use filtered videos or fallback to widget videos
        if (filteredVideos.isNotEmpty) {
          _userRealVideos = filteredVideos;
          print("✅ Using filtered videos: ${_userRealVideos.length}");
        } else {
          _userRealVideos = widget.userVideos;
          print("📦 Using fallback widget videos: ${_userRealVideos.length}");
        }
      }
    } catch (e) {
      print('❌ Error loading user videos: $e');
      // Fallback to provided videos
      _userRealVideos = widget.userVideos;
      print("🆘 Using emergency fallback: ${_userRealVideos.length}");
    }

    setState(() {
      _isLoadingUserVideos = false;
    });

    print("🏁 Finished loading user videos: ${_userRealVideos.length}");
  }

  void _handleScroll() {
    const expandedHeight = 200.0;
    final isExpanded = _scrollController.hasClients &&
        _scrollController.offset < expandedHeight;

    if (_isAppBarExpanded != isExpanded) {
      setState(() => _isAppBarExpanded = isExpanded);
    }
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
  void didUpdateWidget(ProfilePageView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if isCurrentUser changed and reinitialize TabController if needed
    if (oldWidget.isCurrentUser != widget.isCurrentUser) {
      _tabController.dispose();
      final tabLength = widget.isCurrentUser ? 4 : 3;
      _tabController = TabController(length: tabLength, vsync: this);
      print(
          '🔄 TabController reinitialized with length: $tabLength for isCurrentUser: ${widget.isCurrentUser}');
    }
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

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, profileState) {
          return _buildContent(profileState, widget.isCurrentUser);
        },
      ),
    );
  }

  // Function to get current user ID
  String? _getCurrentUserId() {
    try {
      return UserCubit.to.state.data?.id;
    } catch (e) {
      return null;
    }
  }

  // Function to get app bar title based on profile type
  String _getAppBarTitle(bool isCurrentUser) {
    if (isCurrentUser) {
      return context.isArabic ? 'ملف شخصي' : 'My Profile';
    } else {
      // For other users, show their name
      final userName = widget.user?.firstName ?? widget.user?.lastName ?? '';
      return userName.isNotEmpty
          ? userName
          : (context.isArabic ? 'الملف الشخصي' : 'Profile');
    }
  }

  Widget _buildContent(
      ProfileState profileState, bool isCurrentUserFromProfile) {
    debugPrint('Profile State: ${profileState.status}');
    debugPrint('Has Profile: ${profileState.hasProfile}');
    debugPrint('User Videos Count: ${_userRealVideos.length}');
    debugPrint('Is Loading User Videos: $_isLoadingUserVideos');
    debugPrint('Is Current User (ProfileEntity): $isCurrentUserFromProfile');

    if (profileState.isLoading && !profileState.hasProfile) {
      return const Center(
        child: StarLoadingIndicator(),
      );
    }

    if (profileState.isError && !profileState.hasProfile) {
      return Center(
        child: StarErrorWidget(
          message: profileState.failure?.toString() ?? 'Failed to load profile',
          onRetry: () {
            if (isCurrentUserFromProfile) {
              _profileCubit.getMyProfile();
            } else if (widget.profileId != null) {
              _profileCubit.getProfileById(widget.profileId!);
            }
          },
        ),
      );
    }

    return NestedScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          // Add the app bar as a sliver so it can scroll with the content
          SliverAppBar(
            // expandedHeight: kToolbarHeight,
            pinned: false,
            floating: true,
            snap: true,
            toolbarHeight: 40,
            // titleSpacing: 0,
            backgroundColor: AppColors.PRIMARY_COLOR,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                ManageVibration.vibrate();
                Navigator.pop(context);
              },
            ),
            actions: [
              if (isCurrentUserFromProfile)
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    ManageVibration.vibrate();
                    _showEditProfileSheet();
                  },
                ),
            ],
            title: Text(
              _getAppBarTitle(isCurrentUserFromProfile),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileHeader(
              profile: profileState.profile,
              user: widget.user,
              isCurrentUser: isCurrentUserFromProfile,
              videosCount: _getVideosCount(profileState),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: _SliverTabBarDelegate(
              ProfileTabBar(
                tabController: _tabController,
                isCurrentUser: isCurrentUserFromProfile,
              ),
            ),
          ),
        ];
      },
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: BlocProvider.value(
          value: _starCubit,
          child: ProfileTabsContent(
            tabController: _tabController,
            extendedVideos: _userRealVideos,
            isCurrentUser: isCurrentUserFromProfile,
            userId: isCurrentUserFromProfile ? null : widget.user?.id,
            isLoadingUserVideos: _isLoadingUserVideos,
          ),
        ),
      ),
    );
  }

  int _getVideosCount(ProfileState profileState) {
    // Return actual user videos count
    if (_userRealVideos.isNotEmpty) {
      return _userRealVideos.length;
    }

    // Fallback to profile data or widget data
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
  double get minExtent => 56.0;

  @override
  double get maxExtent => 56.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 56.0,
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
