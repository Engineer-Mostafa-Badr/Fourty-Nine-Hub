import 'package:fourtyninehub/features/social_media/instagram/data/models/comment_instagram_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/user_tag_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/user_tag_entity.dart';

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
      id: json['postId'] ?? '',
      content: json['content'] ?? '',
      userId: json['owner']?['userId'] ?? '',
      firstName: json['owner']?['firstName'] ?? '',
      lastName: json['owner']?['lastName'] ?? '',
      username: json['owner']?['username'] ?? '',
      locationName: json['location']?['name'] ?? '',
      profilePictureUrl: json['owner']?['profilePictureUrl'] ?? '',
      verifiedBadge: json['owner']?['verifiedBadge'] ?? false,
      medias: json['mediaUrls'] != null
          ? List<String>.from(
              json['mediaUrls'].map((x) => x).toList(),
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
          ? List<String>.from(json['hashtags'].map((x) => x).toList())
          : [],
      favoritesCounter: json['favoritesCounter'] ?? 0,
      commentsCounter: json['commentsCounter'] ?? 0,
      likesCounter: json['likesCounter'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      countOfStory: json['owner']?['countOfStory'] ?? 0,
      isFriend: json['owner']?['isFriend'] ?? false,
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
