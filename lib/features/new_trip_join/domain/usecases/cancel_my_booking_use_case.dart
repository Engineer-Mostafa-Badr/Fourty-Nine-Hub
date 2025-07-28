
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';

import '../../../../core/error/failure.dart';

class CancelMyBookingUseCase {
  final CaptainShareRepository repository;

  CancelMyBookingUseCase(this.repository);

  Future<Either<Failure, bool>> call(String id) {
    return repository.cancelMyBooking(id);
  }
}

