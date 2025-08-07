import 'package:dartz/dartz.dart';
import '../entities/reels_specific_user_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetInstagramReelsSpecificUserUseCase extends UseCase<
    ReelsSpecificUserDataEntity, GetInstagramReelsSpecificUserParams> {
  final InstagramRepo _repo;
  GetInstagramReelsSpecificUserUseCase(this._repo);
  @override
  Future<Either<Failure, ReelsSpecificUserDataEntity>> call(
      GetInstagramReelsSpecificUserParams params) async {
    return await _repo.getReelsSpecificUser(params: params);
  }
}

class GetInstagramReelsSpecificUserParams {
  final String userId;
  final int page;
  final int limit;

  GetInstagramReelsSpecificUserParams({
    required this.userId,
    required this.page,
    required this.limit,
  });
}
