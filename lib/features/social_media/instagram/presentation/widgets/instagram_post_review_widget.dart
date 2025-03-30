import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/description_post.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/icon_action_post_insta.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/liked_by_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstagramPostReviewWidget extends StatelessWidget {
  const InstagramPostReviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const IconsActionPostInsta(
          likes: 34666,
          comments: 567,
          shares: 2021,
        ),
        const SizedBox(
          height: 10,
        ),
        const LikedByWidget(
          imageUrl: testImage2,
          name: 'craig_love',
          others: 44686,
        ),
        const SizedBox(
          height: 10,
        ),
        const DescriptionPost(
          name: 'Username',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec leo lacus, bibendum sed consectetur sed, elementum at tellus. Sed vel ultricies eros. Nulla in lectus nulla. Nunc tristique leo sit amet leo congue, vel vulputate nulla ornare. Donec ultrices varius suscipit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Ut eget varius purus. Duis ut efficitur mi.',
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Label(
            text: 'September 19',
            style: Styles.mediumText(
              color: const Color(0x66000000),
            ),
          ),
        ),
      ],
    );
  }
}
