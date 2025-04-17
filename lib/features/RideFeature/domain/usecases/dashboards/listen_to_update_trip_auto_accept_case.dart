import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_auto_accept_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';
//
// class ListenToUpdateTripAutoAcceptUseCase {
//   final TripRepository repository;
//   ListenToUpdateTripAutoAcceptUseCase(this.repository);
//
//   Future<Either<Failure, UpdateTripAutoAcceptEntity>> call(NoParams params) {
//     return repository.listenToUpdateTripAutoAccept();
//   }
// }

class ListenToUpdateTripAutoAcceptUseCase
    extends NormalUseCase<void, Function(UpdateTripAutoAcceptEntity)> {
  final TripRepository _repo;
  ListenToUpdateTripAutoAcceptUseCase(this._repo);

  @override
  void call(Function(UpdateTripAutoAcceptEntity trip) params) {
    return _repo.listenToUpdateTripAutoAccept(params);
  }
}
