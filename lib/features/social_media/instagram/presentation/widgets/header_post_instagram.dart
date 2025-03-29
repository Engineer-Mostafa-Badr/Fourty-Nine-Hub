import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_buttom_sheet_without_mention_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_user_info_with_mention_post_widget.dart';

class HeaderPostInstagram extends StatelessWidget {
  const HeaderPostInstagram({
    super.key,
    required this.isMenchan,
    required this.imageUrl,
    required this.userName,
    this.country,
    this.songName,
    required this.isReel,
    this.userNameMenchan,
    this.numberUserNamesMenchan,
    this.userImageMenchan,
  });

  final bool isMenchan;
  final String imageUrl;
  final String userName;

  final String? country;
  final String? songName;
  final bool isReel;
  final String? userNameMenchan;
  final int? numberUserNamesMenchan;
  final String? userImageMenchan;

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
            isMenchan: isMenchan,
            userNameMenchan: userNameMenchan,
            numberUserNamesMenchan: numberUserNamesMenchan,
            userImageMenchan: userImageMenchan,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.white,
                context: context,
                builder: (context) =>
                    const InstagramPostButtomSheetWithoutMentionWidget(),
              );
            },
            child: const Icon(Icons.more_vert_sharp),
          ),
        ],
      ),
    );
  }
}
