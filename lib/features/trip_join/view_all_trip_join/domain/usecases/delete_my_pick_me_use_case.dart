import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/delete_my_trip_join_entity.dart';
import '../repos/view_all_trip_join_repo.dart';

class DeleteMyPickMeUseCase
    extends UseCase<DeleteMyTripJoinEntity , String> {
  final ViewAllTripJoinRepo _repo;
  DeleteMyPickMeUseCase(this._repo);

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity >> call(String params) {
    return _repo.deleteMyPickMe(params);
  }
}
