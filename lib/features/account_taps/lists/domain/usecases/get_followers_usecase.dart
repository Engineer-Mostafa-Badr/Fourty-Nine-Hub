import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/users_list_entity.dart';
import '../repositories/lists_repo.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';

class GetFollowersUseCase extends UseCase<List<UserFriendEntity>, NoParams> {
  final ListsRepo _repo;
  GetFollowersUseCase(this._repo);
  @override
  Future<Either<Failure, List<UserFriendEntity>>> call(NoParams params) async {
    return await _repo.getFollowers();
  }
}
