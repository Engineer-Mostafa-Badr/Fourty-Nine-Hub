import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/client_not_shown_use_case.dart';

class CaptainArrivedToClientUseCase {
  final CaptainShareRepository repository;

  CaptainArrivedToClientUseCase(this.repository);

  Future<Either<Failure, String>> call(ClientNotShownParams params) {
    return repository.arrivedToClient(params);
  }
}
