import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/read_more_text.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../domain/entities/instagram_post_entity.dart';

class DescriptionPost extends StatelessWidget {
  const DescriptionPost({
    super.key,
    required this.instagramPostEntity,
  });
  final InstagramPostEntity instagramPostEntity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: ReadMoreText(
        username: instagramPostEntity.username,
        description: instagramPostEntity.content,
        usernameStyle: Styles.mediumText(
          fontWeight: FontWeight.w600,
        ),
        descriptionStyle: Styles.mediumText(),
      ),
    );
  }
}