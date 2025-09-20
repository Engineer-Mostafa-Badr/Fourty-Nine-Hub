import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class TwitterRepostUseCase {
  final TwitterRepo repository;

  TwitterRepostUseCase(this.repository);

  Future<Either<Failure, String>> call(String postId) async {
    return await repository.repostPost(postId);
  }
}
