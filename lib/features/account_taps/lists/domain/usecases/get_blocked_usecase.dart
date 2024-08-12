import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/users_list_entity.dart';
import '../repositories/lists_repo.dart';

class GetBlockedUseCase extends UseCase<List<UsersListEntity>, NoParams> {
  final ListsRepo _repo;
  GetBlockedUseCase(this._repo);
  @override
  Future<Either<Failure, List<UsersListEntity>>> call(NoParams params) async {
    return await _repo.getBlockedUsers();
  }
}
