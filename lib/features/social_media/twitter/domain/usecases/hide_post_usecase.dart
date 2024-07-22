import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class HidePostUseCase extends UseCase<bool, String> {
  final TwitterRepo _repo;
  HidePostUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await _repo.deletePost(postId: params);
  }
}
