import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/follow_button_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_buttom_sheet_without_mention_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_user_info_with_mention_post_widget.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../core/error/failure.dart';
import '../cubit/profile_instagram_cubit/profile_instagram_cubit.dart';

class HeaderPostInstagram extends StatelessWidget {
  const HeaderPostInstagram({
    super.key,
    required this.userTags,
    required this.imageUrl,
    required this.userName,
    this.country,
    this.songName,
    required this.isReel,
    required this.userId,
    required this.isFollow,
    required this.postId,
  });

  final List<InstagramPostUserTagEntity> userTags;
  final String imageUrl;
  final String userName;
  final String? country;
  final String? songName;
  final bool isReel;
  final String userId;
  final String postId;
  final bool isFollow;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ProfileInstagramCubit>(),
      child: BlocBuilder<ProfileInstagramCubit, ProfileInstagramState>(
        builder: (context, state) {
          return SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InstagramUserInfoWithMentionPostWidget(
                    country: country,
                    isReel: isReel,
                    songName: songName,
                    imageUrl: imageUrl,
                    userName: userName,
                    userTags: userTags,
                    userId: userId,
                  ),
                  const Spacer(),
                  if (userId != context.read<UserCubit>().state.data?.id)
                    BlocConsumer<ProfileInstagramCubit, ProfileInstagramState>(
                      listener: (context, state) {
                        if (state.addFollowStatus == LoadingStatus.failure) {
                          showErrorMessage(
                            context,
                            getFailureMessage(
                              state.addFollowFailure!,
                              context,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return FollowButtonInstagram(
                          isReel: isReel,
                          isFollow: isFollow,
                          onPressed: () {
                            if (isFollow) {
                              context
                                  .read<ProfileInstagramCubit>()
                                  .unFollowUser(userId);
                            } else {
                              context
                                  .read<ProfileInstagramCubit>()
                                  .followUser(userId);
                            }
                          },
                        );
                      },
                    ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (context) =>
                            InstagramPostButtomSheetWithoutMentionWidget(
                          userId: userId,
                          postId: postId,
                        ),
                      );
                    },
                    child: Icon(
                      Icons.more_vert_sharp,
                      color: isReel ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
