import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class TwitterSharePostUseCase extends UseCase<bool, String> {
  final TwitterRepo _repo;
  TwitterSharePostUseCase(this._repo);
  @override
  // Future<Either<Failure, bool>> call(String params) async {
  //   return await _repo.sharePost(postId: params);
  // }
  Future<Either<Failure, bool>> call(String params) async {
    return await _repo.sharePost(postId: params);
  }
}
