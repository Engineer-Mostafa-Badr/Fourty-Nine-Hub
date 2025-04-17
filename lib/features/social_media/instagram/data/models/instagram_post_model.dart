import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';

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
    required super.likesCounter,
    required super.firstName,
    required super.lastName,
    required super.createdAt,
    required super.countOfStory,
    required super.isFriend,
  });

  factory InstagramPostModel.fromJson(Map<String, dynamic> json) {
    return InstagramPostModel(
      id: json['postId'],
      content: json['content'],
      userId: json['owner']?['userId'],
      firstName: json['owner']?['firstName'] ?? '',
      lastName: json['owner']?['lastName'] ?? '',
      username: json['owner']?['username'],
      locationName: json['location']?['name'],
      profilePictureUrl: json['owner']?['profilePictureUrl'],
      verifiedBadge: json['owner']?['verifiedBadge'],
      medias: json['mediaUrls'] != null
          ? List<String>.from(
              json['mediaUrls'].map((x) => x).toList(),
            )
          : [],
      comments: json['comments'] != null
          ? List<CommentsEntity>.from(
              json['comments'].map((x) => CommentsModel.fromJson(x)).toList(),
            )
          : [],
      userTags: json['userTags'] != null
          ? List<UserTagEntity>.from(
              json['userTags'].map((x) => UserTagsModel.fromJson(x)).toList(),
            )
          : [],
      hashtags: json['hashtags'] != null
          ? List<String>.from(json['hashtags'].map((x) => x).toList())
          : [],
      favoritesCounter: json['favoritesCounter'],
      commentsCounter: json['commentsCounter'],
      likesCounter: json['likesCounter'],
      createdAt: json['createdAt'] ?? 'null',
      countOfStory: json['owner']?['countOfStory'] ?? 0,
      isFriend: json['owner']?['isFriend'] ?? false,
    );
  }
}

class CommentsModel extends CommentsEntity {
  CommentsModel({required super.id});

  factory CommentsModel.fromJson(Map<String, dynamic> json) {
    return CommentsModel(
      id: json['id'],
    );
  }
}

class UserTagsModel extends UserTagEntity {
  UserTagsModel(
      {required super.username,
      required super.firstName,
      required super.lastName,
      required super.profilePictureUrl});

  factory UserTagsModel.fromJson(Map<String, dynamic> json) {
    return UserTagsModel(
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePictureUrl: json['profilePictureUrl'],
    );
  }
}
