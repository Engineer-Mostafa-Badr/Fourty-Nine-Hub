import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/pagination_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';

class InstagramPostDataEntity {
  final List<InstagramPostEntity> posts;
  final PaginationEntity pagination;

  InstagramPostDataEntity({
    required this.posts,
    required this.pagination,
  });
}
