import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';

import '../../../../../service_locator/service_locator.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../domain/entity/star_entity.dart';
import '../../presentation_exports.dart';

class TubeNavigationHelper {
  /// Navigate to video player with video URL and talent
  static void navigateToVideoPlayer({
    required BuildContext context,
    required String videoUrl,
    required StarEntity talent,
    required StarCubit cubit,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<StarCubit>.value(
              value: cubit,
            ),
            BlocProvider<CommentCubit>(
              create: (context) => serviceLocator<CommentCubit>(),
            ),
          ],
          child: TalentVideoPlayer(
            videoUrl: videoUrl,
            talent: talent,
          ),
        ),
      ),
    );
  }

  /// Navigate to profile page
  static void navigateToProfile({
    required BuildContext context,
    required StarEntity talent,
  }) {
    final currentUserId = UserCubit.to.state.data?.id;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => serviceLocator<StarCubit>(),
          child: BlocProvider<ProfileCubit>(
            create: (context) {
              final profileCubit = serviceLocator<ProfileCubit>();
              profileCubit.getProfileById(talent.user.id);
              return profileCubit;
            },
            child: BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, profileState) {
                if (profileState.isSuccess && profileState.profile != null) {
                  final profileUserId = profileState.profile!.userId;
                  final isCurrentUser = currentUserId == profileUserId;

                  print("🔍 Profile Navigation Debug:");
                  print("   Current User ID: $currentUserId");
                  print("   Profile User ID: $profileUserId");
                  print("   Is Current User: $isCurrentUser");
                }
              },
              builder: (context, profileState) {
                bool isCurrentUser = false;
                if (profileState.profile != null) {
                  isCurrentUser = currentUserId == profileState.profile!.userId;
                } else {
                  isCurrentUser = currentUserId == talent.user.id;
                }

                return ProfilePageView(
                  user: talent.user,
                  userVideos: [],
                  isCurrentUser: isCurrentUser,
                  profileId: talent.user.id,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Show video not available snackbar
  static void showVideoNotAvailableMessage(BuildContext context) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    // context.isArabic
    //     ? TubeConstants.videoNotAvailableAr
    //     : TubeConstants.videoNotAvailableEn,
    //     ),
    //     duration: Duration(seconds: 4),
    //     backgroundColor: Colors.orange[700],
    //   ),
    // );
    showSuccessMessage(
      context,
      context.isArabic
          ? TubeConstants.videoNotAvailableAr
          : TubeConstants.videoNotAvailableEn,
    );
  }

  /// Check if video is available and handle navigation
  static void handleVideoTap({
    required BuildContext context,
    required StarEntity talent,
    required String mediaUrl,
    required StarCubit cubit,
    VoidCallback? onVideoStarted,
  }) {
    if (!talent.isApproved) {
      showVideoNotAvailableMessage(context);
      return;
    }

    // Fetch video details before navigation
    cubit.fetchVideoDetails(talent.id);

    // Call the optional callback (for incrementing views, etc.)
    onVideoStarted?.call();

    navigateToVideoPlayer(
      context: context,
      videoUrl: mediaUrl,
      talent: talent,
      cubit: cubit,
    );
  }
}
