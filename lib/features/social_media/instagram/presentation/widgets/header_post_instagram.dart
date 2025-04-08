import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/follow_button_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_buttom_sheet_without_mention_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_user_info_with_mention_post_widget.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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

  final List<UserTagEntity> userTags;
  final String imageUrl;
  final String userName;
  final String? country;
  final String? songName;
  final bool isReel;
  final String userId;

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
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
  }
}
