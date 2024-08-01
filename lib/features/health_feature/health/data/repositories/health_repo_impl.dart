import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';

import '../../domain/repositories/health_repo.dart';
import '../datasources/health_remote_datasource.dart';

class HealthRepoImpl implements HealthRepo {
  final HealthRemoteDataSource _remoteDataSource;
  HealthRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<BookedAppointmentEntity>>>
      getMyBookingsHistory() async {
    return await _remoteDataSource.getMyBookingsHistory();
  }
  
  @override
  Future<Either<Failure, List<BookedAppointmentEntity>>> getUpcomingBookings() {
    return _remoteDataSource.getUpcomingBookings();
  }

  @override
  Future<Either<Failure, List<HealthSubcategoryEntity>>> getHealthSubcategories() {
    return _remoteDataSource.getHealthSubcategories();
  }
}
