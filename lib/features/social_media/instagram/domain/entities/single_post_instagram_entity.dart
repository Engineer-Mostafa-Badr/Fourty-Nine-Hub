import 'package:fourtyninehub/features/social_media/instagram/domain/entities/last_like_enyity.dart';

class SinglePostInstagramEntity {
  final String id;
  final String content;
  final List<String> hashtags;
  final List<String> mediaUrls;
  final OwnerEntity owner;
  final List<TaggedUserEntity> taggedUsers;
  final int likesCounter;
  final int commentsCounter;
  final int shearsCounter;
  final int favoritesCounter;
  final List<CommentEntity> comments;
  final bool isLiked;
  final LastLikeEntity lastLikeEntity;

  SinglePostInstagramEntity({
    required this.id,
    required this.content,
    required this.hashtags,
    required this.mediaUrls,
    required this.owner,
    required this.taggedUsers,
    required this.likesCounter,
    required this.commentsCounter,
    required this.shearsCounter,
    required this.favoritesCounter,
    required this.comments,
    required this.isLiked,
    required this.lastLikeEntity,
  });
}

class OwnerEntity {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String profilePictureUrl;
  final int hasStory;
  final bool verifiedBadge;
  final bool isFollow;

  OwnerEntity({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.profilePictureUrl,
    required this.hasStory,
    required this.verifiedBadge,
    required this.isFollow,
  });
}

class TaggedUserEntity {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String profilePictureUrl;

  TaggedUserEntity({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.profilePictureUrl,
  });
}

class CommentEntity {
  final String id;
  final String content;
  final OwnerEntity owner;
  final List<CommentEntity> replies;
  final String createdAt;

  CommentEntity({
    required this.id,
    required this.content,
    required this.owner,
    required this.replies,
    required this.createdAt,
  });
}
