import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';


class CompleteRouteUseCase {
  final CaptainShareRepository repository;

  CompleteRouteUseCase(this.repository);

  Future<Either<Failure, bool>> call(String id) {
    return repository.completeRoute(id);
  }
}

