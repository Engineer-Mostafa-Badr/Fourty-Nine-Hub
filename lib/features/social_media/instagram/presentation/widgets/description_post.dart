import 'package:flutter/material.dart';
import 'read_more_text.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

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
        text: '${instagramPostEntity.username} ${instagramPostEntity.content}',
        // description: instagramPostEntity.content,
        style: Styles.mediumText(
          fontWeight: FontWeight.w600,
          color: AppColors.getTextColor(context),
        ),
        // descriptionStyle: Styles.mediumText(
        //   color: AppColors.getTextColor(context),
        // ),
      ),
    );
  }
}