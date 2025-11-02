import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/friends_stories_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/user_basic_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/user_with_stories_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/presentation/logic/spot_light_cubit.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/widget/clickable_widget.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../stories/presentation/cubit/stories_cubit.dart';
import '../../../stories/presentation/pages/create_story_screen.dart';
import '../../../stories/presentation/pages/more_stories.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import 'package:story_view/controller/story_controller.dart';

import '../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../stories/data/models/friends_stories_model.dart';

class FriendsStories extends StatefulWidget {
  const FriendsStories({super.key});

  @override
  State<FriendsStories> createState() => _FriendsStoriesState();
}

class _FriendsStoriesState extends State<FriendsStories> {
  @override
  void initState() {
    super.initState();
    // Load friends stories when widget is initialized
    context.read<SpotlightCubit>().getFriendsStories();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              // My Story section
              SizedBox(height: 100, child: _createMyStory(context)),
              const SizedBox(width: 6),
              // Friends Stories section
              BlocBuilder<SpotlightCubit, SpotLightState>(
                builder: (context, state) {
                  if (state is SpotlightFriendsStoriesLoading) {
                    return _buildLoadingStories();
                  } else if (state is SpotlightFriendsStoriesLoaded) {
                    return _buildFriendsStoriesList(state.friendsStories);
                  } else if (state is SpotlightError) {
                    return _buildErrorWidget(context);
                  }

                  // Default fallback or initial state
                  return _buildEmptyStories();
                },
              ),
              const Sizer(width: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingStories() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (context, index) => const Sizer(width: 8),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: _buildShimmerStoryItem(),
        ),
      ),
    );
  }

  Widget _buildShimmerStoryItem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
          child: Padding(
            padding: EdgeInsets.all(6.h),
            child: Container(
              padding: EdgeInsets.all(1.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              child: CircleAvatar(
                radius: 48.h,
                backgroundColor: Colors.grey[300],
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: 60,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }

  Widget _buildFriendsStoriesList(FriendsStoriesEntity friendsStories) {
    if (friendsStories.stories.isEmpty) {
      return _buildEmptyStories();
    }

    return SizedBox(
      height: 100,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: friendsStories.stories.length,
        separatorBuilder: (context, index) => const Sizer(width: 8),
        itemBuilder: (context, index) {
          final userWithStories = friendsStories.stories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: _buildStoryItem(context, userWithStories, index),
          );
        },
      ),
    );
  }

  Widget _buildEmptyStories() {
    return Center(
      child: Text(
        'No stories available',
        style: Styles.mediumText(
          color: context.isDarkMode ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: context.isDarkMode ? Colors.white70 : Colors.black54,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            'Failed to load stories',
            style: Styles.smallText(
              color: context.isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createMyStory(BuildContext context) {
    return FittedBox(
      child: GestureDetector(
        onTap: () async {
          ManageVibration.vibrate();
          context.read<UserCubit>().isLoggedIn
              ? await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CameraScreen(),
                  ),
                )
              : pleaseLoginDialog(context);

          // Refresh stories after creating a new one
          context.read<SpotlightCubit>().getFriendsStories(forceRefresh: true);
          BlocProvider.of<StoryCubit>(context)
            ..fetchStories()
            ..getMutedStories();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(6.h),
                child: Container(
                  padding: EdgeInsets.all(1.h),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  child: CircleAvatar(
                    radius: 48.h,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: CircleAvatar(
                            backgroundColor: AppColors.PRIMARY_COLOR,
                            backgroundImage: NetworkImage(
                              serviceLocator<UserCubit>().state.data != null &&
                                      context.isUserLoggedIn
                                  ? serviceLocator<UserCubit>()
                                      .state
                                      .data!
                                      .profilePicture!
                                  : UIConst.profilePlaceHolder,
                            ),
                            onBackgroundImageError: (_, __) => Image.asset(
                              UIConst.profilePlaceHolder,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          right: -6,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            padding: const EdgeInsets.all(3),
                            child: CircleAvatar(
                              backgroundColor: AppColors.PRIMARY_COLOR,
                              radius: 14.h,
                              child: Icon(
                                Icons.add,
                                size: 25.h,
                                color: Colors.white,
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
            const SizedBox(height: 2),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: context.isArabic ? "قصتي" : "My Story",
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryItem(
      BuildContext context, UserWithStoriesEntity userWithStories, int index) {
    final userController = StoryController();

    return FittedBox(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          ManageVibration.vibrate();
          context.read<UserCubit>().isLoggedIn
              ? await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: serviceLocator<StoryCubit>(),
                      child: StoryViewScreen(
                        stories: _convertUserWithStoriesToUserStories(
                            [userWithStories]), // Convert the type
                        initialUserIndex: 0,
                      ),
                    ),
                  ),
                )
              : pleaseLoginDialog(context);

          // Refresh stories after viewing to update seen status
          context.read<SpotlightCubit>().getFriendsStories(forceRefresh: true);
          BlocProvider.of<StoryCubit>(context)
            ..fetchStories()
            ..getMutedStories();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClickableWidget(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _getStoryGradient(userWithStories),
                ),
                child: Padding(
                  padding: EdgeInsets.all(6.h),
                  child: Container(
                    padding: EdgeInsets.all(1.h),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: CircleAvatar(
                      radius: 48.h,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: CircleAvatar(
                              backgroundColor: AppColors.PRIMARY_COLOR,
                              backgroundImage:
                                  _getProfileImage(userWithStories.user),
                            ),
                          ),
                          if (userWithStories.storyCount > 1)
                            Positioned(
                              bottom: -4,
                              right: -6,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                padding: const EdgeInsets.all(6),
                                child: Text(
                                  '${userWithStories.storyCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
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
            ),
            const SizedBox(height: 2),
            FittedBox(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: '${userWithStories.user.firstName}\n',
                    style: Styles.mediumText(
                        fontWeight: FontWeight.w400,
                        color:
                            context.isDarkMode ? Colors.white : Colors.black),
                  ),
                  TextSpan(
                    text: "@${userWithStories.user.username}",
                    style: Styles.smallText(
                        color: context.isDarkMode
                            ? Colors.white
                            : Colors.black.withOpacity(0.7)),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to convert UserWithStoriesEntity to UserStories
  List<UserStories> _convertUserWithStoriesToUserStories(
      List<UserWithStoriesEntity> userWithStoriesList) {
    return userWithStoriesList.map((userWithStories) {
      return UserStories(
        user: UserData(
          id: userWithStories.user.userId,
          firstName: userWithStories.user.firstName,
          lastName: userWithStories.user.lastName,
          profilePictureUrl: userWithStories.user.userProfileUrl,
        ),
        stories: userWithStories.stories.map((story) {
          return Story(
            id: story.id,
            // viewCount: story.viewCount,
            // type: story.type,
            // content: story.content,
            // caption: story.caption,
            // thumbnailUrl: story.thumbnailUrl,
            // createdAt: story.createdAt,
            // color: story.color,
            // fontFamily: story.fontFamily,
            // isLiked: story.isLiked,
          );
        }).toList(),
      );
    }).toList();
  }

  LinearGradient _getStoryGradient(UserWithStoriesEntity userWithStories) {
    // Check if user has any unviewed stories
    final hasUnviewedStories =
        userWithStories.stories.any((story) => !story.isViewed);

    if (hasUnviewedStories) {
      // Colorful gradient for unviewed stories
      return const LinearGradient(
        colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      // Gray gradient for viewed stories
      return LinearGradient(
        colors: [Colors.grey[400]!, Colors.grey[600]!],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  ImageProvider _getProfileImage(UserBasicEntity user) {
    if (user.userProfileUrl != null && user.userProfileUrl!.isNotEmpty) {
      return NetworkImage(user.userProfileUrl!);
    } else {
      return AssetImage(Assets.spotlight_profile);
    }
  }
}
