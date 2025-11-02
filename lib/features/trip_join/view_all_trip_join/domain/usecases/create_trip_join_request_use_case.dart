import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/create_pick_me_request_use_case.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/delete_my_trip_join_entity.dart';
import '../repos/view_all_trip_join_repo.dart';

class CreateTripJoinRequestUseCase
    extends UseCase<DeleteMyTripJoinEntity, CreateRequestParams> {
  final ViewAllTripJoinRepo _repo;
  CreateTripJoinRequestUseCase(this._repo);

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> call(
      CreateRequestParams params) {
    return _repo.createTripJoinRequest(params);
  }
}
