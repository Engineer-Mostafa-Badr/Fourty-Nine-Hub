import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/description_post.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/icon_action_post_insta.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/post_instagram_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/liked_by_widget.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';

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
          instagramPostEntity: instagramPostEntity,
        ),
        const SizedBox(
          height: 10,
        ),
        if (instagramPostEntity.likesCounter != 0)
          LikedByWidget(
            imageUrl: testImage2,
            name: 'craig_love',
            others: instagramPostEntity.likesCounter - 1,
          ),
        if (instagramPostEntity.likesCounter != 0)
          const SizedBox(
            height: 10,
          ),
        DescriptionPost(
          instagramPostEntity: instagramPostEntity,
        ),
        const Sizer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Label(
            text: FormatDate().fromatDateLikeMonthDay(
                // context, '2025-04-05T22:39:39.466Z'),
                context, instagramPostEntity.createdAt!),
            style: Styles.mediumText(
              color: context.isDarkMode
                  ? const Color(0x66FFFFFF)
                  : const Color(0x66000000),
            ),
          ),
        ),
      ],
    );
  }
}
