import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetFeedUseCase extends UseCase<List<PostEntity>, NoParams> {
  final SocialPostsRepo _repo;
  GetFeedUseCase(this._repo);
  @override
  Future<Either<Failure, List<PostEntity>>> call(NoParams params) async {
    return await _repo.getFeed();
  }
}
