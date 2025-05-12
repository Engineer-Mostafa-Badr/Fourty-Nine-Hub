import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';
import 'save_post_instagram_use_case.dart';

class RemoveSavePostInstagramUseCase
    extends UseCase<bool, SavePostInstagramParams> {
  final InstagramRepo _repo;
  RemoveSavePostInstagramUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(
      SavePostInstagramParams params) async {
    return await _repo.removeSavePostInstagram(params);
  }
}