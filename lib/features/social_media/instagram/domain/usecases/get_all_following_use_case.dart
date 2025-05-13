import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/following_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/followers_entity.dart';
import '../repositories/social_posts_repo.dart';
import 'get_all_followers_use_case.dart';

class GetAllFollowingUseCase
    extends UseCase<List<FollowersEntity>, GetAllFollowersParams> {
  final InstagramRepo _repo;
  GetAllFollowingUseCase(this._repo);
  @override
  Future<Either<Failure, List<FollowersEntity>>> call(
      GetAllFollowersParams params) async {
    return await _repo.getAllFollowing(params);
  }
}
