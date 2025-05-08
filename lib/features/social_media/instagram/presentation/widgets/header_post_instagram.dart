import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/follow_button_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_buttom_sheet_without_mention_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_user_info_with_mention_post_widget.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

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
  });

  final List<InstagramPostUserTagEntity> userTags;
  final String imageUrl;
  final String userName;
  final String? country;
  final String? songName;
  final bool isReel;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ProfileInstagramCubit>(),
      child: BlocBuilder<ProfileInstagramCubit, ProfileInstagramState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19),
            child: Row(
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
                FollowButtonInstagram(
                  isReel: isReel,
                  onPressed: () {
                    context
                        .read<ProfileInstagramCubit>()
                        .followUser(userId);
                  },
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (context) =>
                      const InstagramPostButtomSheetWithoutMentionWidget(),
                    );
                  },
                  child: Icon(
                    Icons.more_vert_sharp,
                    color: isReel ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
