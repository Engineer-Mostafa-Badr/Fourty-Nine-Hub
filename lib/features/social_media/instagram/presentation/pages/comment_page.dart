import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/comment_instagram_entity.dart';

class CommentInstagramBottomSheet extends StatelessWidget {
  const CommentInstagramBottomSheet({
    super.key,
    required this.commentInstagramEntity,
    required this.scrollController,
    required this.scrollableSheetController,
  });

  final CommentInstagramEntity commentInstagramEntity;
  final ScrollController scrollController;
  final DraggableScrollableController scrollableSheetController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView();
  }
}
