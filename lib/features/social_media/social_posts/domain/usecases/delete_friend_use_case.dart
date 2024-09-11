import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/repositories/social_posts_repo.dart';

class DeleteFriendUseCase extends UseCase<bool, String> {
  final SocialPostsRepo _repo;
  DeleteFriendUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await _repo.deleteFriend(userId: params);
  }
}
