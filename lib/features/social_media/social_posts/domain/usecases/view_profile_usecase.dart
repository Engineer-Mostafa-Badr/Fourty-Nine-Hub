import 'package:dartz/dartz.dart';
import '../repositories/social_posts_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class ViewProfileUseCase extends UseCase<bool, String> {
  final SocialPostsRepo _repo;
  ViewProfileUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await _repo.viewProfile(params: params);
  }
}
