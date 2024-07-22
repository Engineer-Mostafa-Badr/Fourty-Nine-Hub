import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_main_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';

import '../../../../../core/utils/duration_helper.dart';
import '../../../../../res/assets/assets.dart';

class TwitterPostEntity {
  final String id;
  final String content;
  final List<String>? images;
  final List<String>? shares;
  final List<TwitterUserModel>? love;
  final TwitterMainPostEntity? mainPost;
  final bool isShared;
  final TwitterUserEntity user;
  final List<TwitterCommentEntity> comments;
  final int commentPrivacy;
  final num commentsCount;
  final num sharesCount;
  final num loveCount;
  final DateTime createdAt;
   Duration get publishedDuration => DateTime.now().difference(createdAt);

  String get sinceTime =>
      DurationHelper().sinceTime(duration: publishedDuration);
 
  TwitterPostEntity({
    required this.id,
    required this.content,
    this.images,
    this.shares,
    this.love,
    required this.user,
    this.commentPrivacy = 1,
    this.isShared = false,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.loveCount = 0,
    this.mainPost,
    required this.createdAt,
    required this.comments
  });
}

enum Reactions { like, love, wow, sad, angry }

extension ReactionX on Reactions {
  String value() {
    switch (this) {
      case Reactions.like:
        return 'like';
      case Reactions.love:
        return 'love';
      case Reactions.wow:
        return 'wow';
      case Reactions.sad:
        return 'sad';
      case Reactions.angry:
        return 'angry';
    }
  }
  String label() {
    switch (this) {
      case Reactions.like:
        return 'Like';
      case Reactions.love:
        return 'Love';
      case Reactions.wow:
        return 'Wow';
      case Reactions.sad:
        return 'Sad';
      case Reactions.angry:
        return 'Angry';
    }
  }
  String image() {
    switch (this) {
      case Reactions.like:
        return Assets.like;
      case Reactions.love:
        return Assets.heart;
      case Reactions.wow:
        return Assets.wow;
      case Reactions.sad:
        return Assets.sad;
      case Reactions.angry:
        return Assets.angry;
    }
  }
}
