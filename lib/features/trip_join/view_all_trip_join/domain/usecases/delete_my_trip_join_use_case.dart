import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/delete_my_trip_join_entity.dart';
import '../repos/view_all_trip_join_repo.dart';

class DeleteMyTripJoinUseCase
    extends UseCase<DeleteMyTripJoinEntity , DeleteMyTripParams> {
  final ViewAllTripJoinRepo _repo;
  DeleteMyTripJoinUseCase(this._repo);

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity >> call(DeleteMyTripParams params) {
    return _repo.deleteMyTripJoin(params);
  }
}
class DeleteMyTripParams{
  final String tripId;

  DeleteMyTripParams({required this.tripId});
}
