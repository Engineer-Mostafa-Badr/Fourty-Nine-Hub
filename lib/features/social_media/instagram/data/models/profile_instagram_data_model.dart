import '../../../../account_taps/wallet/data/models/pagination_model.dart';
import '../../domain/entities/profile_instagram_data_entity.dart';

class ProfileInstagramDataModel extends ProfileInstagramDataEntity {
  ProfileInstagramDataModel({
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.bio,
    required super.profilePictureUrl,
    required super.postsCount,
    required super.friendsCount,
    required super.followersCount,
    required super.followingCount,
    required super.viewsCount,
    required super.postsEntity,
    required super.paginationEntity,
  });

  factory ProfileInstagramDataModel.fromJson(Map<String, dynamic> json) {
    return ProfileInstagramDataModel(
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      bio: json['bio'] ?? '',
      profilePictureUrl: json['profilePictureUrl'] ?? '',
      postsCount: json['postsCounter'] ?? 0,
      friendsCount: json['friendsCounter'] ?? 0,
      followersCount: json['followersCounter'] ?? 0,
      followingCount: json['followingCounter'] ?? 0,
      viewsCount: json['viewsCounter'] ?? 0,
      postsEntity: List<InstagramProfilePostEntity>.from(
        (json['posts'] ?? []).map((e) => InstagramProfilePostModel.fromJson(e)),
      ),
      paginationEntity:
          PaginationModel.fromJson(json['paginationEntity'] ?? {}),
    );
  }
}

class InstagramProfilePostModel extends InstagramProfilePostEntity {
  InstagramProfilePostModel({
    required super.id,
    required super.content,
    required super.mediaUrls,
    required super.commentsCount,
    required super.likesCount,
    required super.createdAt,
  });

  factory InstagramProfilePostModel.fromJson(Map<String, dynamic> json) {
    return InstagramProfilePostModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      commentsCount: json['commentsCount'] ?? 0,
      likesCount: json['likesCount'] ?? 0,
      createdAt: json['createdAt'] ?? '',
    );
  }
}
