import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/requests_history/data/models/trip_model.dart';
import '../repositories/trip_details_repo.dart';

class GetTripDetailsUseCase extends UseCase<TripModel,int> {
  final TripDetailsRepo _repository;

  const GetTripDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, TripModel>> call(int params) {
    return _repository.getTripDetails(tripId: params);
  }
}
