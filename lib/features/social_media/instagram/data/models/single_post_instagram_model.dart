import '../../domain/entities/single_post_instagram_entity.dart';

import 'last_like_model.dart';

class SinglePostInstagramModel extends SinglePostInstagramEntity {
  SinglePostInstagramModel({
    required super.id,
    required super.content,
    required super.hashtags,
    required super.mediaUrls,
    required super.owner,
    required super.taggedUsers,
    required super.likesCounter,
    required super.commentsCounter,
    required super.shearsCounter,
    required super.favoritesCounter,
    required super.comments,
    required super.isLiked,
    required super.lastLikeEntity,
  });

  factory SinglePostInstagramModel.fromJson(Map<String, dynamic> json) {
    return SinglePostInstagramModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      hashtags: List<String>.from(json['hashtags'] ?? []),
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      owner: OwnerModel.fromJson(json['owner'] ?? {}),
      taggedUsers: json['taggedUsers'] != null
          ? List<TaggedUserModel>.from(
              (json['taggedUsers'] as List)
                  .map((t) => TaggedUserModel.fromJson(t)),
            )
          : [],
      likesCounter: json['likesCounter'] ?? 0,
      commentsCounter: json['commentsCounter'] ?? 0,
      shearsCounter: json['shareCounter'] ?? 0,
      favoritesCounter: json['favoritesCounter'] ?? 0,
      lastLikeEntity: LastLikeModel.fromJson(json['lastLikeUser']),
      isLiked: json['isLiked'] ?? false,
      comments: json['comments'] != null
          ? List<CommentModel>.from(
              (json['comments'] as List).map((t) => CommentModel.fromJson(t)),
            )
          : [],
    );
  }
}

class OwnerModel extends OwnerEntity {
  OwnerModel({
    required super.id,
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.profilePictureUrl,
    required super.hasStory,
    required super.verifiedBadge,
    required super.isFollow,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profilePictureUrl: json['profilePictureUrl'] ?? '',
      hasStory: json['hasStory'] ?? 0,
      verifiedBadge: json['verifiedBadge'] ?? false,
      isFollow: json['isFollowed'] ?? false,
    );
  }
}

class TaggedUserModel extends TaggedUserEntity {
  TaggedUserModel({
    required super.id,
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.profilePictureUrl,
  });

  factory TaggedUserModel.fromJson(Map<String, dynamic> json) {
    return TaggedUserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profilePictureUrl: json['profilePictureUrl'] ?? '',
    );
  }
}

class CommentModel extends CommentEntity {
  CommentModel({
    required super.id,
    required super.content,
    required super.owner,
    required super.replies,
    required super.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      owner: OwnerModel.fromJson(json['owner'] ?? {}),
      replies: (json['replies'] != null && json['replies'] is List)
          ? List<CommentModel>.from(
              (json['replies'] as List).map((c) => CommentModel.fromJson(c)),
            )
          : [],
      createdAt: json['createdAt'] ?? '',
    );
  }
}
