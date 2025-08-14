import 'package:dartz/dartz.dart';
import '../../../../account_taps/lists/domain/entities/user_friend_entity.dart';
import '../repositories/social_posts_repo.dart';
import '../../../twitter/domain/usecases/get_feed_usecase.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

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
