import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/requests_history/data/models/trip_model.dart';
import 'package:fourtyninehub/features/requests_history/domain/repositories/history_ride_repo.dart';

class GetHistoryRideUseCase extends UseCase<List<TripModel>, NoParams> {
  final RequestHistoryRepo _repository;

  const GetHistoryRideUseCase(this._repository);

  @override
  Future<Either<Failure, List<TripModel>>> call(NoParams params) {
    return _repository.getRideHistory();
  }
}
