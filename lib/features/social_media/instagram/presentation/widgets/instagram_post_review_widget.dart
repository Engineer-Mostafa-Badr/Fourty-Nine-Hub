import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/description_post.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/icon_action_post_insta.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/post_instagram_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/liked_by_widget.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstagramPostReviewWidget extends StatelessWidget {
  const InstagramPostReviewWidget(
      {super.key, required this.instagramPostEntity});

  final InstagramPostEntity instagramPostEntity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconsActionPostInsta(
          likes: instagramPostEntity.likesCounter,
          comments: instagramPostEntity.commentsCounter,
          shares: 2021,
          postId: instagramPostEntity.id,
        ),
        const SizedBox(
          height: 10,
        ),
        LikedByWidget(
          imageUrl: testImage2,
          name: 'craig_love',
          others: instagramPostEntity.likesCounter - 1,
        ),
        const SizedBox(
          height: 10,
        ),
        DescriptionPost(
          name: instagramPostEntity.username,
          description: instagramPostEntity.content,
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Label(
            text: FormatDate().fromatDateLikeMonthDay(
                context, instagramPostEntity.createdAt!),
            style: Styles.mediumText(
              color: const Color(0x66000000),
            ),
          ),
        ),
      ],
    );
  }
}
