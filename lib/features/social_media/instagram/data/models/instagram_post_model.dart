import 'comment_instagram_model.dart';
import 'last_like_model.dart';
import '../../domain/entities/instagram_post_entity.dart';

class InstagramPostMediaUrlModel extends InstagramPostMediaUrlEntity {
  InstagramPostMediaUrlModel({
    required super.url,
    required super.id,
  });

  factory InstagramPostMediaUrlModel.fromJson(Map<String, dynamic> json) {
    return InstagramPostMediaUrlModel(
      url: json['url']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
    );
  }
}

class InstagramPostModel extends InstagramPostEntity {
  InstagramPostModel({
    required super.id,
    required super.content,
    required super.userId,
    required super.username,
    required super.locationName,
    required super.profilePictureUrl,
    required super.verifiedBadge,
    required super.medias,
    required super.comments,
    required super.userTags,
    required super.hashtags,
    required super.favoritesCounter,
    required super.commentsCounter,
    required super.shareCounter,
    required super.likesCounter,
    required super.firstName,
    required super.lastName,
    required super.createdAt,
    required super.countOfStory,
    required super.isFriend,
    required super.isFollow,
    required super.isLiked,
    required super.lastLikeEntity,
  });

  factory InstagramPostModel.fromJson(Map<String, dynamic> json) {
    return InstagramPostModel(
      id: json['postId']?.toString() ?? '',
      // Default to empty string if null
      content: json['content']?.toString() ?? '',
      userId: json['owner']?['userId']?.toString() ?? '0',
      // Ensure userId is not null
      firstName: json['owner']?['firstName']?.toString() ?? '',
      lastName: json['owner']?['lastName']?.toString() ?? '',
      username: json['owner']?['username']?.toString() ?? '',
      locationName: json['location']?['name']?.toString() ?? '',
      // Handle null location
      profilePictureUrl: json['owner']?['profilePictureUrl']?.toString() ?? '',
      // Handle null
      verifiedBadge: json['owner']?['verifiedBadge'] ?? false,
      // Default to false if null
      medias: json['mediaUrls'] != null
          ? List<InstagramPostMediaUrlEntity>.from(
              json['mediaUrls']
                  .map((x) => InstagramPostMediaUrlModel.fromJson(x))
                  .toList(),
            )
          : [],
      comments: json['comments'] != null
          ? List<CommentInstagramModel>.from(
              json['comments']
                  .map((x) => CommentInstagramModel.fromJson(x))
                  .toList(),
            )
          : [],
      userTags: json['userTags'] != null
          ? List<InstagramPostUserTagEntity>.from(
              json['userTags']
                  .map((x) => InstagramPostUserTagModel.fromJson(x))
                  .toList(),
            )
          : [],
      hashtags: json['hashtags'] != null
          ? List<String>.from(json['hashtags']
              .map((x) => x ?? '')
              .toList()) // Handle null hashtags
          : [],
      favoritesCounter: json['favoritesCounter'] ?? 0,
      // Default to 0 if null
      commentsCounter: json['commentsCounter'] ?? 0,
      // Default to 0 if null
      shareCounter: json['shareCounter'] ?? 0,
      // Default to 0 if null
      likesCounter: json['likesCounter'] ?? 0,
      // Default to 0 if null
      createdAt: json['createdAt']?.toString() ?? '',
      // Default to empty string if null
      countOfStory: json['owner']?['countOfStory'] ?? 0,
      // Default to 0 if null
      isFriend: json['owner']?['isFriend'] ?? false,
      // Default to false if null
      isFollow: json['owner']?['isFollowed'] ?? false,
      // Default to false if null
      isLiked: json['isLiked'] ?? false,
      // Default to false if null
      lastLikeEntity: json['lastLikeUser'] != null
          ? LastLikeModel.fromJson(json['lastLikeUser'])
          : null,
    );
  }
}

class InstagramPostUserTagModel extends InstagramPostUserTagEntity {
  InstagramPostUserTagModel(
      {required super.username,
      required super.firstName,
      required super.lastName,
      required super.profilePictureUrl});

  factory InstagramPostUserTagModel.fromJson(Map<String, dynamic> json) {
    return InstagramPostUserTagModel(
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profilePictureUrl: json['profilePictureUrl'] ?? '',
    );
  }
}

// class CommentsModel extends CommentsEntity {
//   CommentsModel({required super.id});

//   factory CommentsModel.fromJson(Map<String, dynamic> json) {
//     return CommentsModel(
//       id: json['id'],
//     );
//   }
// }

// class UserTagsModel extends UserTagEntity {
//   UserTagsModel(
//       {required super.username,
//       required super.firstName,
//       required super.lastName,
//       required super.profilePictureUrl});
//
//   factory UserTagsModel.fromJson(Map<String, dynamic> json) {
//     return UserTagsModel(
//       username: json['username'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       profilePictureUrl: json['profilePictureUrl'],
//     );
//   }
// }
