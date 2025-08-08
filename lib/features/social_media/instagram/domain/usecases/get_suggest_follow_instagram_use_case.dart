import 'package:dartz/dartz.dart';
import '../entities/data_suggest_follow_instagram_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetSuggestFollowInstagramUseCase extends UseCase<
    DataSuggestFollowInstagramEntity, GetSuggestFollowInstagramParams> {
  final InstagramRepo _repo;
  GetSuggestFollowInstagramUseCase(this._repo);
  @override
  Future<Either<Failure, DataSuggestFollowInstagramEntity>> call(
      GetSuggestFollowInstagramParams params) async {
    return await _repo.getSuggestFollowInstagram(params);
  }
}

class GetSuggestFollowInstagramParams {
  final int limit;
  final int page;
  GetSuggestFollowInstagramParams({required this.limit, required this.page});
}
