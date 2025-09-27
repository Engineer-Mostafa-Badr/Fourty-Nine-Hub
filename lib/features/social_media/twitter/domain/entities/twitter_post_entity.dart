import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';

import '../../../../../core/utils/time_utils.dart';
import '../../data/models/twitter_user_model.dart';
import 'twitter_main_post_entity.dart';

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
  bool? isLiked;
  bool? isReposted;
  final dynamic user;
  final List<String> comments;
  final int commentPrivacy;
  num? commentsCount;
  num? sharesCount;
  num? loveCount;
  num? repostCount;
  bool? isReact;
  bool? yourReposted;
  String? photo;
  final DateTime createdAt;
  Duration get publishedDuration => TimeUtils.calculateDuration(createdAt);

  String get sinceTime => TimeUtils.getSinceTime(createdAt);
  final TwitterThreadEntity? thread;

  TwitterPostEntity({
    required this.id,
    required this.content,
    required this.isLiked,
    this.postShare,
    this.images,
    this.shares,
    this.love,
    this.isReact = false,
    this.yourReposted = false,
    required this.user,
    this.commentPrivacy = 1,
    this.isShared = false,
    this.isReposted = false,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.loveCount = 0,
    this.repostCount = 0,
    this.mainPost,
    this.photo,
    this.thread,
    required this.createdAt,
    required this.comments,
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
// lib/features/social_media/twitter/domain/entities/twitter_thread_entity.dart

class TwitterThreadEntity {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TwitterUserModel owner;
  const TwitterThreadEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.owner,
  });
}

class TwitterThreadDetail {
  final TwitterThreadEntity meta;
  final List<TwitterPostEntity> posts;
  final List<TwitterPostCommentEntity> replies;
  const TwitterThreadDetail({
    required this.meta,
    required this.posts,
    required this.replies,
  });
}
