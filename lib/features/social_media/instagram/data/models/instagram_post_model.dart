import 'package:fourtyninehub/features/social_media/instagram/data/models/comment_instagram_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';

import 'package:fourtyninehub/features/social_media/instagram/data/models/comment_instagram_model.dart';
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
      id: json['postId']?.toString() ?? '', // Default to empty string if null
      content: json['content']?.toString() ?? '',
      userId: json['owner']?['userId']?.toString() ?? '', // Ensure userId is not null
      firstName: json['owner']?['firstName']?.toString() ?? '',
      lastName: json['owner']?['lastName']?.toString() ?? '',
      username: json['owner']?['username']?.toString() ?? '',
      locationName: json['location']?['name']?.toString() ?? '', // Handle null location
      profilePictureUrl: json['owner']?['profilePictureUrl']?.toString() ?? '', // Handle null
      verifiedBadge: json['owner']?['verifiedBadge'] ?? false, // Default to false if null
      medias: json['mediaUrls'] != null
          ? List<String>.from(json['mediaUrls'].map((x) => x ?? '').toList()) // Handle null in mediaUrls
          : [],
      comments: json['comments'] != null
          ? List<CommentInstagramModel>.from(
        json['comments'].map((x) => CommentInstagramModel.fromJson(x)).toList(),
      )
          : [],
      userTags: json['userTags'] != null
          ? List<UserTagsModel>.from(
        json['userTags'].map((x) => UserTagsModel.fromJson(x)).toList(),
      )
          : [],
      hashtags: json['hashtags'] != null
          ? List<String>.from(json['hashtags'].map((x) => x ?? '').toList()) // Handle null hashtags
          : [],
      favoritesCounter: json['favoritesCounter'] ?? 0, // Default to 0 if null
      commentsCounter: json['commentsCounter'] ?? 0, // Default to 0 if null
      likesCounter: json['likesCounter'] ?? 0, // Default to 0 if null
      createdAt: json['createdAt']?.toString() ?? '', // Default to empty string if null
      countOfStory: json['owner']?['countOfStory'] ?? 0, // Default to 0 if null
      isFriend: json['owner']?['isFriend'] ?? false, // Default to false if null
    );
  }
}

class UserTagsModel extends UserTagEntity {
  UserTagsModel({
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.profilePictureUrl,
  });

  factory UserTagsModel.fromJson(Map<String, dynamic> json) {
    return UserTagsModel(
      username: json['username']?.toString() ?? '', // Default to empty string if null
      firstName: json['firstName']?.toString() ?? '', // Default to empty string if null
      lastName: json['lastName']?.toString() ?? '', // Default to empty string if null
      profilePictureUrl: json['profilePictureUrl']?.toString() ?? '', // Default to empty string if null
    );
  }
}

