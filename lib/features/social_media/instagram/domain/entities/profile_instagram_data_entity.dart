import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/pagination_entity.dart';

class ProfileInstagramDataEntity {
  final String username;
  final String firstName;
  final String lastName;
  final String bio;
  final String profilePictureUrl;
  final int postsCount;
  final int friendsCount;
  final int followersCount;
  final int followingCount;
  final List<InstagramProfilePostEntity> postsEntity;
  final PaginationEntity paginationEntity;

  const ProfileInstagramDataEntity({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.profilePictureUrl,
    required this.postsCount,
    required this.friendsCount,
    required this.followersCount,
    required this.followingCount,
    required this.postsEntity,
    required this.paginationEntity,
  });
}

class InstagramProfilePostEntity {
  final String id;
  final String content;
  final List<String> mediaUrls;
  final int commentsCount;
  final int likesCount;
  final String createdAt;

  const InstagramProfilePostEntity({
    required this.id,
    required this.content,
    required this.mediaUrls,
    required this.commentsCount,
    required this.likesCount,
    required this.createdAt,
  });
}
