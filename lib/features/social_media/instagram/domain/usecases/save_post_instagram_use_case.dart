import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class SavePostInstagramUseCase
    extends UseCase<bool, SavePostInstagramParams> {
  final InstagramRepo _repo;
  SavePostInstagramUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(
      SavePostInstagramParams params) async {
    return await _repo.savePostInstagram(params);
  }
}

class SavePostInstagramParams {
  final String postId;
  SavePostInstagramParams({required this.postId});
}
