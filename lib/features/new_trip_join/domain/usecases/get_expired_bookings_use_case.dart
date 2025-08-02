
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';

import '../../../../core/error/failure.dart';

class GetExpiredBookingsUseCase {
  final CaptainShareRepository repository;

  GetExpiredBookingsUseCase(this.repository);

  Future<Either<Failure, List<MyBookingEntity>>> call(PaginationParams params) {
    return repository.getExpiredBooking(params);
  }
}

