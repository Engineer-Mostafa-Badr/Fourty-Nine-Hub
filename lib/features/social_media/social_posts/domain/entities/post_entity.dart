import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import '../../../../../core/utils/duration_helper.dart';
import '../../../../../res/assets/assets.dart';

class PostEntity {
  final String id;
  final String content;
  final List<String>? images;
  final bool isShared;
  bool? isLove;
  bool? isLikes;
  bool? isWow;
  bool? isSad;
  bool? isAngry;
  final TwitterUserEntity user;
  // final List<CommentEntity> comments;
  final int privacy;
  final int commentPrivacy;
  final num commentsCount;
  final num sharesCount;
  num? likesCount;
  num? loveCount;
  num? wowCount;
  num? sadCount;
  num? angryCount;
  num? totalCount;
  final DateTime createdAt;
   Duration get publishedDuration => DateTime.now().difference(createdAt);

  String get sinceTime =>
      DurationHelper().sinceTime(duration: publishedDuration);
 
  PostEntity({
    required this.id,
    required this.content,
    this.images,
    required this.user,
    this.commentPrivacy = 1,
    this.privacy = 1,
    this.isShared = false,
    this.isLove = false,
    this.isLikes = false,
    this.isWow = false,
    this.isSad = false,
    this.isAngry = false,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.likesCount = 0,
    this.loveCount = 0,
    this.wowCount = 0,
    this.sadCount = 0,
    this.angryCount = 0,
    this.totalCount = 0,
    required this.createdAt,
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
