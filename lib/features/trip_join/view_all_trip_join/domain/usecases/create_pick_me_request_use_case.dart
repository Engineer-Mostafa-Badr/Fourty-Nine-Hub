import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/delete_my_trip_join_entity.dart';
import '../repos/view_all_trip_join_repo.dart';

class CreatePickMeRequestUseCase
    extends UseCase<DeleteMyTripJoinEntity, CreateRequestParams> {
  final ViewAllTripJoinRepo _repo;
  CreatePickMeRequestUseCase(this._repo);

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> call(
      CreateRequestParams params) {
    return _repo.createPickMeRequest(params);
  }
}

class CreateRequestParams {
  final String offerId;
  final String phoneNumber;
  final bool isPremium;

  CreateRequestParams(
      {required this.offerId,
      required this.phoneNumber,
      required this.isPremium});

  //toJson
  Map<String, dynamic> toJson() {
    return {
      "offerId": offerId,
      "phoneNumber": phoneNumber,
      "isPremium": isPremium
    };
  }
}
