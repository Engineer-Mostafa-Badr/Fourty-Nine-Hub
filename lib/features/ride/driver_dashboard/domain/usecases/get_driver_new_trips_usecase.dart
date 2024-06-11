import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../../history_ride/data/models/trip_model.dart';
import '../repositories/driver_dashboard_repo.dart';

class GetDriverNewTripsUseCase extends UseCase<List<TripModel>, NoParams> {
  final DriverDashboardRepo _repository;

  const GetDriverNewTripsUseCase(this._repository);

  @override
  Future<Either<Failure, List<TripModel>>> call(NoParams params) {
    return _repository.getNewTrips();
  }
}
