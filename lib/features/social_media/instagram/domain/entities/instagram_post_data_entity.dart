import '../../../../account_taps/wallet/domain/entities/pagination_entity.dart';
import 'instagram_post_entity.dart';

class InstagramPostDataEntity {
  final List<InstagramPostEntity> posts;
  final PaginationEntity pagination;

  InstagramPostDataEntity({
    required this.posts,
    required this.pagination,
  });
}
