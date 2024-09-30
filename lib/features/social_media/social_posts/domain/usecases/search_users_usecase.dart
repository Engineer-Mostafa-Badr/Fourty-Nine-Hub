import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/repositories/social_posts_repo.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';

class SearchUsersUsecase
    extends UseCase<List<UserFriendEntity>, TwitterFeedParams> {
  final SocialPostsRepo _repo;
  SearchUsersUsecase(this._repo);
  @override
  Future<Either<Failure, List<UserFriendEntity>>> call(
      TwitterFeedParams params) async {
    return await _repo.searchUsers(params: params);
  }
}
