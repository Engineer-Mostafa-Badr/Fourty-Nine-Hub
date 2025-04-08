import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/instagram_post_data_model.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetPostsUseCase
    extends UseCase<InstagramPostDataModel, PaginationParams> {
  final InstagramRepo _repo;
  GetPostsUseCase(this._repo);
  @override
  Future<Either<Failure, InstagramPostDataModel>> call(
      PaginationParams params) async {
    return await _repo.getPosts(params);
  }
}

// enum FeedItemType {
//   post,
//   reel,
//   friendSuggestion,
// }

// abstract class FeedItem {
//   final String id;
//   final FeedItemType type;

//   const FeedItem({
//     required this.id,
//     required this.type,
//   });

//   // @override
//   // List<Object> get props => [id, type];
// }
