import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class RemoveSuggestUserUseCase extends UseCase<bool, String> {
  final SocialPostsRepo _repo;
  RemoveSuggestUserUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await _repo.removeSuggestUser(userId: params);
  }
}
