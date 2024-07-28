import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class GetUserPostsUseCase extends UseCase<List<TwitterPostEntity>, String> {
  final TwitterRepo _repo;
  GetUserPostsUseCase(this._repo);
  @override
  Future<Either<Failure, List<TwitterPostEntity>>> call(String params) async {
    return await _repo.getUserPosts(userId: params);
  }
}
