import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetInstagramGlobalFeedUseCase
    extends UseCase<List<PostEntity>, TwitterFeedParams> {
  final InstagramRepo _repo;
  GetInstagramGlobalFeedUseCase(this._repo);
  @override
  Future<Either<Failure, List<PostEntity>>> call(
      TwitterFeedParams params) async {
    return await _repo.getGlobalFeed(params: params);
  }
}
