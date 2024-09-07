import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/lists_repo.dart';

class GetFriendsUsecase extends UseCase<List<UserFriendEntity>, NoParams> {
  final ListsRepo _repo;
  GetFriendsUsecase(this._repo);
  @override
  Future<Either<Failure, List<UserFriendEntity>>> call(NoParams params) async {
    return await _repo.getFriendsList();
  }
}
