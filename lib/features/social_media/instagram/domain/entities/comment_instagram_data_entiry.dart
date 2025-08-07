import '../../../../account_taps/wallet/domain/entities/pagination_entity.dart';
import 'comment_instagram_entity.dart';

class CommentInstagramDataEntiry {
  final List<CommentInstagramEntity> comments;
  final PaginationEntity pagination;

  CommentInstagramDataEntiry({
    required this.comments,
    required this.pagination,
  });
}
