import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/pagination_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';

class ProfileInstagramDataEntity {
  final String username;
  final String profilePictureUrl;
  final int postsCount;
  final int friendsCount;
  final int followersCount;
  final int followingCount;
  final List<InstagramPostEntity> postsEntity;
  final PaginationEntity paginationEntity;

  const ProfileInstagramDataEntity({
    required this.username,
    required this.profilePictureUrl,
    required this.postsCount,
    required this.friendsCount,
    required this.followersCount,
    required this.followingCount,
    required this.postsEntity,
    required this.paginationEntity,
  });
}
