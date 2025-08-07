import 'package:dartz/dartz.dart';
import '../entities/followers_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetAllFollowersUseCase
    extends UseCase<List<FollowersEntity>, GetAllFollowersParams> {
  final InstagramRepo _repo;
  GetAllFollowersUseCase(this._repo);
  @override
  Future<Either<Failure, List<FollowersEntity>>> call(
      GetAllFollowersParams params) async {
    return await _repo.getAllFollowers(params);
  }
}
class GetAllFollowersParams {
  final int page;
  final int limit;
  String? search;
  String? otherId;
  GetAllFollowersParams(
      {required this.page, required this.limit, this.search, this.otherId});
  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'otherId': limit,
  };
}