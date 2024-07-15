
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../repositories/driver_dashboard_repo.dart';

class AcceptRideUseCase extends UseCase<String, String> {
  final DriverDashboardRepo _repository;

  const AcceptRideUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(String params) {
    return _repository.acceptTrip(id: params);
  }
}
