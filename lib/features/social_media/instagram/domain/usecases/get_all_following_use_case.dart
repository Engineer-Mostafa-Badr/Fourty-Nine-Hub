import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/following_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetAllFollowingUseCase
    extends UseCase<List<FollowingEntity>, TwitterFeedParams> {
  final InstagramRepo _repo;
  GetAllFollowingUseCase(this._repo);
  @override
  Future<Either<Failure, List<FollowingEntity>>> call(TwitterFeedParams params) async {
    return await _repo.getAllFollowing(params);
  }
}
