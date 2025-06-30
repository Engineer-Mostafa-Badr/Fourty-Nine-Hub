
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';

class GetDriverAvailableBookingsUseCase {
  final CaptainShareRepository repository;

  GetDriverAvailableBookingsUseCase(this.repository);

  Future<Either<Failure, List<MyBookingEntity>>> call(PaginationParams params) {
    return repository.getDriverAvailableBooking(params);
  }
}

