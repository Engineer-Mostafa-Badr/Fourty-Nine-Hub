import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/lists_repo.dart';

class GetBlockedUseCase extends UseCase<List<UserFriendEntity>, TwitterFeedParams> {
  final ListsRepo _repo;
  GetBlockedUseCase(this._repo);
  @override
  Future<Either<Failure, List<UserFriendEntity>>> call(TwitterFeedParams params) async {
    return await _repo.getBlockedUsers(params: params);
  }
}
