import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';

class IamComingUseCase {
  final CaptainShareRepository repository;

  IamComingUseCase(this.repository);

  Future<Either<Failure, String>> call(String params) {
    return repository.iamComing(params);
  }
}
