import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/repositories/social_posts_repo.dart';

class AcceptRejectFriendRequestUseCase
    extends UseCase<bool, AcceptRejectFriendRequestParams> {
  final SocialPostsRepo _repo;
  AcceptRejectFriendRequestUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(
      AcceptRejectFriendRequestParams params) async {
    return await _repo.acceptRejectFriendRequest(params: params);
  }
}

class AcceptRejectFriendRequestParams {
  final String userId;
  final bool status;

  AcceptRejectFriendRequestParams({required this.userId, required this.status});
  Map<String, dynamic> toJson() => {
        'status': status,
      };
}
