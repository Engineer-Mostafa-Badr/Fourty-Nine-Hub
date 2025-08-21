import 'package:dartz/dartz.dart';
import '../entities/post_entity.dart';
import '../../../twitter/domain/usecases/get_feed_usecase.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class FaceGlobalAdvertisementUseCase
    extends UseCase<List<PostEntity>, TwitterFeedParams> {
  final SocialPostsRepo _repo;
  FaceGlobalAdvertisementUseCase(this._repo);
  @override
  Future<Either<Failure, List<PostEntity>>> call(
      TwitterFeedParams params) async {
    return await _repo.getGlobalAdvertisement(params: params);
  }
}
