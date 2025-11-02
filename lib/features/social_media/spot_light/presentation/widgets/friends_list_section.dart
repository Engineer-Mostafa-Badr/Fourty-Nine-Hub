import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/features/social_media/spot_light/presentation/logic/spot_light_cubit.dart';
import 'package:fourtyninehub/features/social_media/spot_light/presentation/widgets/friends_stories.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class FriendsList extends StatelessWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              LocaleKeys.friends_title.tr(),
              textScaler: TextScaler.noScaling,
              style: Styles.headerText(fontWeight: FontWeight.bold),
            ),
          ),
          BlocBuilder<SpotlightCubit, SpotLightState>(
            builder: (context, state) {
              if (state is SpotlightFriendsStoriesLoaded) {
                return FriendsStoriesWidget(
                    friendsStories: state.friendsStories);
              } else if (state is SpotlightFriendsStoriesLoading) {
                return const Center(child: CustomCircularProgressIndicator());
              }
              // Fallback to the old stories cubit
              return BlocProvider<StoryCubit>(
                create: (_) => serviceLocator()
                  ..fetchStories()
                  ..getMutedStories(),
                child: const FriendsStories(),
              );
            },
          ),
        ],
      ),
    );
  }
}

// New widget to display friends stories from spotlight cubit
class FriendsStoriesWidget extends StatelessWidget {
  final dynamic friendsStories; // Using dynamic to avoid import issues

  const FriendsStoriesWidget({super.key, required this.friendsStories});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(width: 8),
            // // My Story widget (same as in ChatStories)
            // SizedBox(height: 120.h, child: _createMyStory(context)),
            const SizedBox(width: 6),
            // Friends stories
            ...friendsStories.stories.map<Widget>((userStory) {
              final hasUnviewed =
                  userStory.stories.any((story) => !story.isViewed);
              final storiesCount = userStory.stories.length ?? 0;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: FittedBox(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // Navigate to story viewer
                      context
                          .read<SpotlightCubit>()
                          .viewStory(userStory.stories.first.id);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Profile with stories border
                        ProfileWithStoriesBorder(
                          profilePictureUrl:
                              userStory.user.userProfileUrl ?? '',
                          storiesCount: storiesCount,
                          hasUnviewed: hasUnviewed,
                        ),
                        SizedBox(height: 8.h),
                        // Name
                        FittedBox(
                          child: SizedBox(
                            width: 80.w,
                            child: Text(
                              _capitalizeAndSplit2Only(
                                  userStory.user.firstName ?? ''),
                              textScaler: TextScaler.noScaling,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 20),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  // Widget _createMyStory(BuildContext context) {
  //   return FittedBox(
  //     child: GestureDetector(
  //       onTap: () async {
  //         // Add your navigation logic here
  //         // Similar to the ChatStories implementation
  //       },
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Container(
  //             decoration: const BoxDecoration(
  //               shape: BoxShape.circle,
  //               gradient: LinearGradient(
  //                 colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
  //                 begin: Alignment.topCenter,
  //                 end: Alignment.bottomCenter,
  //               ),
  //             ),
  //             child: Padding(
  //               padding: const EdgeInsets.all(4.0),
  //               child: Container(
  //                 padding: const EdgeInsets.all(4),
  //                 decoration: const BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.all(Radius.circular(100)),
  //                 ),
  //                 child: CircleAvatar(
  //                   radius: MediaQuery.of(context).size.width * 0.1,
  //                   child: Stack(
  //                     clipBehavior: Clip.none,
  //                     children: [
  //                       Positioned.fill(
  //                         child: CircleAvatar(
  //                           backgroundColor: AppColors.PRIMARY_COLOR,
  //                           backgroundImage: AssetImage(Assets.personalImage),
  //                           // Add your profile image logic here
  //                         ),
  //                       ),
  //                       Positioned(
  //                         bottom: -8,
  //                         right: -12,
  //                         child: Container(
  //                           decoration: const BoxDecoration(
  //                             shape: BoxShape.circle,
  //                             gradient: LinearGradient(
  //                               colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
  //                               begin: Alignment.topCenter,
  //                               end: Alignment.bottomCenter,
  //                             ),
  //                           ),
  //                           padding: const EdgeInsets.all(3),
  //                           child: CircleAvatar(
  //                             backgroundColor: Theme.of(context).brightness ==
  //                                     Brightness.dark
  //                                 ? Colors.white
  //                                 : AppColors.PRIMARY_COLOR,
  //                             radius: 18,
  //                             child: Icon(
  //                               Icons.add,
  //                               size: 24,
  //                               color: Theme.of(context).brightness ==
  //                                       Brightness.dark
  //                                   ? const Color(0xff0D0D0D)
  //                                   : Colors.white,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 2),
  //           FittedBox(
  //             child: Text(
  //               "My Story", // Add localization logic here
  //               textScaler: TextScaler.noScaling,
  //               maxLines: 1,
  //               overflow: TextOverflow.ellipsis,
  //               style:
  //                   const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  String _capitalizeAndSplit2Only(String text) {
    if (text.isEmpty) return text;
    List<String> words = text.split(' ');
    if (words.isEmpty) return text;
    String firstWord = words.first;
    return firstWord[0].toUpperCase() + firstWord.substring(1).toLowerCase();
  }
}

// Custom widget for profile with stories border
class ProfileWithStoriesBorder extends StatelessWidget {
  final String profilePictureUrl;
  final int storiesCount;
  final bool hasUnviewed;

  const ProfileWithStoriesBorder({
    super.key,
    required this.profilePictureUrl,
    required this.storiesCount,
    this.hasUnviewed = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StoriesBorderPainter(
        storiesCount: storiesCount,
        hasUnviewed: hasUnviewed,
      ),
      child: Container(
        width: 80.w,
        height: 80.h,
        padding: const EdgeInsets.all(4),
        child: CircleAvatar(
          radius: 38.w,
          backgroundImage: profilePictureUrl.isNotEmpty
              ? NetworkImage(profilePictureUrl)
              : AssetImage(Assets.personalImage) as ImageProvider,
        ),
      ),
    );
  }
}

// Custom painter for stories border
class StoriesBorderPainter extends CustomPainter {
  final int storiesCount;
  final bool hasUnviewed;

  StoriesBorderPainter({
    required this.storiesCount,
    this.hasUnviewed = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (storiesCount <= 0) return;

    final double strokeWidth = 3.0;
    final double radius = (size.width / 2) + 4;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Gradient gradient = hasUnviewed
        ? const SweepGradient(
            colors: [
              Color(0xFFFF3308),
              Color(0xFF0B1035),
            ],
            stops: [0.0, 1.0],
          )
        : const SweepGradient(
            colors: [
              Colors.grey,
              Colors.grey,
            ],
            stops: [0.0, 1.0],
          );

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round;

    if (storiesCount == 1) {
      canvas.drawCircle(center, radius, paint);
    } else if (storiesCount == 2) {
      final double dashAngle = (pi * 0.9);
      final double gapAngle = (pi * 0.1);

      final double startAngle1 = -pi / 2 + (gapAngle / 2);
      final double startAngle2 = pi / 2 + (gapAngle / 2);

      canvas.drawArc(rect, startAngle1, dashAngle, false, paint);
      canvas.drawArc(rect, startAngle2, dashAngle, false, paint);
    } else {
      final double totalAngle = 2 * pi;
      final double segmentAngle = totalAngle / storiesCount;
      final double dashAngle = segmentAngle * 0.8;

      for (int i = 0; i < storiesCount; i++) {
        final double startAngle = (i * segmentAngle) - (pi / 2);
        canvas.drawArc(rect, startAngle, dashAngle, false, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
