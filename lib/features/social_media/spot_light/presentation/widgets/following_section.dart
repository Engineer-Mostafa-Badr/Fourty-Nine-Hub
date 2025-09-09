import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/features/social_media/spot_light/presentation/logic/spot_light_cubit.dart';
import 'package:fourtyninehub/features/social_media/spot_light/presentation/pages/other_profile_view.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FollowingSection extends StatefulWidget {
  const FollowingSection({super.key});

  @override
  State<FollowingSection> createState() => _FollowingSectionState();
}

class _FollowingSectionState extends State<FollowingSection> {
  late ScrollController _horizontalScrollController;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  double _previousScrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
    _horizontalScrollController.addListener(_onHorizontalScroll);

    // Load initial friends stories instead of my media
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFollowingContent();
    });
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _loadFollowingContent() {
    // Load friends stories data for following section
    context.read<SpotlightCubit>().getFriendsStories(page: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            LocaleKeys.following_title.tr(),
            textScaler: TextScaler.noScaling,
            style: Styles.headerText(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.65,
          width: double.infinity,
          child: BlocConsumer<SpotlightCubit, SpotLightState>(
            listener: (context, state) {
              if (state is SpotlightError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Error loading following: ${state.failureMessage?.toString() ?? 'Unknown error'}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is SpotlightFriendsStoriesLoading &&
                  _currentPage == 1) {
                return Skeletonizer(
                  enabled: true,
                  child: _buildSkeletonHorizontalList(),
                );
              }

              if (state is SpotlightFriendsStoriesLoaded) {
                final friendsStories = state.friendsStories.stories;

                if (friendsStories.isEmpty) {
                  return _buildEmptyFollowingState();
                }

                return Stack(
                  children: [
                    ListView.builder(
                      controller: _horizontalScrollController,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: friendsStories.length,
                      itemBuilder: (context, index) {
                        final userWithStories = friendsStories[index];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 6.h),
                            child: _buildFollowingUserCard(
                                context, userWithStories, index),
                          ),
                        );
                      },
                    ),
                    if (_isFetchingMore)
                      Positioned(
                        right: 16.w,
                        top: 0,
                        bottom: 0,
                        child: const Center(
                          child: CustomCircularProgressIndicator(),
                        ),
                      ),
                  ],
                );
              }

              return Skeletonizer(
                enabled: true,
                child: _buildSkeletonHorizontalList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonHorizontalList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 8,
      itemBuilder: (context, index) => Container(
        width: MediaQuery.of(context).size.width * 0.4,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
        child: _buildSkeletonCard(),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Card(
      elevation: 6,
      clipBehavior: Clip.hardEdge,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[300],
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          width: 60.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8.h,
              right: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Container(
                  width: 40.w,
                  height: 12.h,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowingUserCard(
      BuildContext context, dynamic userWithStories, int index) {
    final user = userWithStories.user;
    final stories = userWithStories.stories;
    final latestStory = stories.isNotEmpty ? stories.first : null;
    final hasUnviewedStories =
        context.read<SpotlightCubit>().hasUnviewedStories(user.userId);

    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        _showUserStories(context, userWithStories);
      },
      child: Card(
        elevation: 6,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            // Display latest story thumbnail or profile picture
            _buildCardImage(latestStory, user),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),

            // User info and story indicator
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Profile picture with story indicator
                  ClickableWidget(
                    onTap: () => _navigateToUserProfile(context, user.userId),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 24.w,
                          backgroundColor: AppColors.PRIMARY_COLOR,
                          backgroundImage: user.userProfileUrl != null
                              ? NetworkImage(user.userProfileUrl!)
                              : null,
                          child: user.userProfileUrl == null
                              ? Text(
                                  user.firstName.isNotEmpty
                                      ? user.firstName[0].toUpperCase()
                                      : 'U',
                                  style: Styles.mediumText(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        // Story indicator ring
                        if (hasUnviewedStories)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.SECONDARY_COLOR,
                                  width: 3.w,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User full name
                        Text(
                          user.fullName,
                          style: Styles.mediumText(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 28,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        // Latest story time or user info
                        Text(
                          latestStory != null && latestStory.createdAt != null
                              ? _formatDate(latestStory.createdAt!)
                              : '@${user.username}',
                          style: Styles.smallText(
                            color: Colors.white70,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Story count badge
            Positioned(
              top: 8.h,
              right: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY_COLOR.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${userWithStories.storyCount}',
                  style: Styles.smallText(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardImage(dynamic latestStory, dynamic user) {
    String? imageUrl;

    // Use story thumbnail if available, otherwise use profile picture
    if (latestStory != null && latestStory.thumbnailUrl != null) {
      imageUrl = latestStory.thumbnailUrl;
    } else if (user.userProfileUrl != null) {
      imageUrl = user.userProfileUrl;
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Skeletonizer(
            enabled: true,
            child: Container(
              color: Colors.grey[200],
              width: double.infinity,
              height: double.infinity,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) =>
            _buildFallbackCardImage(user),
      );
    }

    return _buildFallbackCardImage(user);
  }

  Widget _buildFallbackCardImage(dynamic user) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
      child: Center(
        child: Text(
          user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : 'U',
          style: Styles.headerText(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyFollowingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 48.w,
            color: Colors.grey,
          ),
          SizedBox(height: 12.h),
          Text(
            "No following content",
            // LocaleKeys.no_following_content.tr(), // Add this key to locale
            style: Styles.mediumText(color: Colors.grey),
          ),
          SizedBox(height: 8.h),
          TextButton(
            onPressed: _loadFollowingContent,
            child: Text(LocaleKeys.refresh.tr()),
          ),
        ],
      ),
    );
  }

  void _showUserStories(BuildContext context, dynamic userWithStories) {
    final stories = userWithStories.stories;
    if (stories.isEmpty) return;

    // Navigate to story viewer or show stories modal
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              userWithStories.user.fullName,
              style: Styles.mediumText(color: Colors.white),
            ),
          ),
          body: PageView.builder(
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return _buildStoryView(context, story);
            },
          ),
        ),
      ),
    );

    // Mark stories as viewed
    for (final story in stories) {
      context.read<SpotlightCubit>().viewStory(story.id);
    }
  }

  Widget _buildStoryView(BuildContext context, dynamic story) {
    if (story.type == 'image' && story.content != null) {
      return Center(
        child: Image.network(
          story.content!,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.error, color: Colors.white, size: 64.w),
        ),
      );
    } else if (story.type == 'text') {
      return Container(
        color: story.color != null
            ? Color(int.parse(story.color!.replaceFirst('#', '0xFF')))
            : Colors.blue,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Text(
              story.content ?? '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontFamily: story.fontFamily,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Center(
      child: Icon(Icons.error, color: Colors.white, size: 64.w),
    );
  }

  void _navigateToUserProfile(BuildContext context, String userId) {
    // Load user profile before navigation
    context.read<SpotlightCubit>().getUserProfile(userId);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<SpotlightCubit>(),
          child: const SpotLightOtherProfileScreen(),
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final DateTime now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  void _onHorizontalScroll() {
    double currentScrollPosition = _horizontalScrollController.position.pixels;
    double maxScrollExtent =
        _horizontalScrollController.position.maxScrollExtent;

    bool isScrollingToEnd = currentScrollPosition > _previousScrollPosition;

    if (isScrollingToEnd &&
        currentScrollPosition >= maxScrollExtent - 50 &&
        !_isFetchingMore) {
      _fetchMoreFollowingContent();
    }

    _previousScrollPosition = currentScrollPosition;
  }

  Future<void> _fetchMoreFollowingContent() async {
    if (_isFetchingMore) return;

    setState(() {
      _isFetchingMore = true;
      _currentPage++;
    });

    try {
      await context
          .read<SpotlightCubit>()
          .getFriendsStories(page: _currentPage, forceRefresh: false);
    } catch (e) {
      _currentPage--;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load more content: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingMore = false;
        });
      }
    }
  }
}
