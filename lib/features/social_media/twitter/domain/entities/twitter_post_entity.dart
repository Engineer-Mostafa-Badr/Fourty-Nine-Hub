import 'package:fourtyninehub/core/utils/time_utils.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_main_post_entity.dart';
import '../../../../../res/assets/assets.dart';

class TwitterPostEntity {
  final String id;
  final String content;
  final List<String>? images;
  final List<String>? shares;
  final List<TwitterUserModel>? love;
   TwitterMainPostEntity? postShare;
  final dynamic mainPost;
  bool? isShared;
  final dynamic user;
  final List<String> comments;
  final int commentPrivacy;
  num? commentsCount;
  num? sharesCount;
  num? loveCount;
  bool? isReact;
  String? photo;
  final DateTime createdAt;
  Duration get publishedDuration => TimeUtils.calculateDuration(createdAt);

  String get sinceTime => TimeUtils.getSinceTime(createdAt);

  TwitterPostEntity(
      {required this.id,
      required this.content,
       this.postShare,
      this.images,
      this.shares,
      this.love,
      this.isReact = false,
      required this.user,
      this.commentPrivacy = 1,
      this.isShared = false,
      this.commentsCount = 0,
      this.sharesCount = 0,
      this.loveCount = 0,
      this.mainPost,
      this.photo,
      required this.createdAt,
      required this.comments});
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
