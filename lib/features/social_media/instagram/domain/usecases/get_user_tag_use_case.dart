import 'package:dartz/dartz.dart';
import '../entities/user_tag_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetUserTagUseCase extends UseCase<List<UserTagEntity>, GetUserTagParams> {
  final InstagramRepo _repo;
  GetUserTagUseCase(this._repo);
  @override
  Future<Either<Failure, List<UserTagEntity>>> call(GetUserTagParams params) async {
    return await _repo.getUserTag(params);
  }
}

class GetUserTagParams {
  final String username;
  final int page;
  final int limit;

  GetUserTagParams({
    required this.username,
    required this.page,
    required this.limit,
  });
}
