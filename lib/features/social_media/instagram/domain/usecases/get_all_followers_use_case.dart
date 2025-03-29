import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/followers_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetAllFollowersUseCase
    extends UseCase<List<FollowersEntity>, TwitterFeedParams> {
  final InstagramRepo _repo;
  GetAllFollowersUseCase(this._repo);
  @override
  Future<Either<Failure, List<FollowersEntity>>> call(
      TwitterFeedParams params) async {
    return await _repo.getAllFollowers(params);
  }
}
