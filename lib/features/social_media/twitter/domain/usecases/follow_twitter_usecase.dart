 import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class GetFollowersCountUseCase {
  final TwitterRepo repo;
  GetFollowersCountUseCase(this.repo);

  Future<Either<Failure, int>> call(String subCategoryId) {
    return repo.getFollowersCount(subCategoryId: subCategoryId);
  }
}

class GetFollowingCountUseCase {
  final TwitterRepo repo;
  GetFollowingCountUseCase(this.repo);

  Future<Either<Failure, int>> call(String subCategoryId) {
    return repo.getFollowingCount(subCategoryId: subCategoryId);
  }
}
