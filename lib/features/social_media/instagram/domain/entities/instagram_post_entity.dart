import 'package:fourtyninehub/features/social_media/instagram/data/models/comment_instagram_model.dart';

import 'last_like_enyity.dart';

class InstagramPostEntity {
  final String id;
  final String content;
  final String userId;
  final String username;
  final String firstName;
  final String lastName;
  final String? locationName;
  final String? profilePictureUrl;
  final bool verifiedBadge;
  final List<String> medias;
  final List<CommentInstagramModel> comments;
  final List<InstagramPostUserTagEntity> userTags;
  final List<String> hashtags;
  final int favoritesCounter;
  final int commentsCounter;
  final int likesCounter;
  final int shareCounter;
  final String? createdAt;
  final int countOfStory;
  final bool isFriend;
  final bool isFollow;
  final bool isLiked;
  final LastLikeEntity? lastLikeEntity;

  InstagramPostEntity({
    required this.id,
    required this.content,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.locationName,
    required this.profilePictureUrl,
    required this.verifiedBadge,
    required this.medias,
    required this.comments,
    required this.userTags,
    required this.hashtags,
    required this.favoritesCounter,
    required this.commentsCounter,
    required this.shareCounter,
    required this.likesCounter,
    required this.createdAt,
    required this.countOfStory,
    required this.isFriend,
    required this.isFollow,
    required this.isLiked,
     this.lastLikeEntity,
  });
}

class InstagramPostUserTagEntity {
  final String username;
  final String firstName;
  final String lastName;
  final String profilePictureUrl;

  InstagramPostUserTagEntity({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.profilePictureUrl,
  });
}

// class UserTagEntity {
//   final String username;
//   final String firstName;
//   final String lastName;
//   final String profilePictureUrl;
//
//   UserTagEntity({
//     required this.username,
//     required this.firstName,
//     required this.lastName,
//     required this.profilePictureUrl,
//   });
// }

// class CommentsEntity {
//   final String id;

//   CommentsEntity({
//     required this.id,
//   });
// }
