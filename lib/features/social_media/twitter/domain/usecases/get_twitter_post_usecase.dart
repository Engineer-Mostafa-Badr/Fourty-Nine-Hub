import 'package:dartz/dartz.dart';
import '../entities/twitter_post_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class GetTwitterPostUseCase extends UseCase<TwitterPostEntity, String> {
  final TwitterRepo _repo;
  GetTwitterPostUseCase(this._repo);
  @override
  Future<Either<Failure, TwitterPostEntity>> call(String params) async {
    return await _repo.getTwitterPost(postId: params);
  }
}
