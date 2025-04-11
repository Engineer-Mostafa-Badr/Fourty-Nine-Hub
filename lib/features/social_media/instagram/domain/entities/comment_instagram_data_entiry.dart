import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/pagination_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/comment_instagram_entity.dart';

class CommentInstagramDataEntiry {
  final List<CommentInstagramEntity> comments;
  final PaginationEntity pagination;

  CommentInstagramDataEntiry({
    required this.comments,
    required this.pagination,
  });
}
