import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/doctor_info_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/favorite_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/most_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_booking_use_case.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_most_booking_use_case.dart';

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
  Future<Either<Failure, List<BookedAppointmentEntity>>> getUpcomingBookings(
      String userId) {
    return _remoteDataSource.getUpcomingBookings(userId);
  }

  @override
  Future<Either<Failure, List<HealthSubcategoryEntity>>> getHealthSubcategories(
      String id) {
    return _remoteDataSource.getHealthSubcategories(id);
  }

  @override
  Future<Either<Failure, List<HealthSubcategoryEntity>>> getMedicalServices(
      String userId) {
    return _remoteDataSource.getMedicalServices(userId);
  }

  @override
  Future<Either<Failure, bool>> isDoctor() {
    return _remoteDataSource.isDoctor();
  }

  @override
  Future<Either<Failure, bool>> isDoctorApproval() {
    return _remoteDataSource.isDoctorApproval();
  }

  @override
  Future<Either<Failure, List<FavoriteCategoryBannersEntity>>>
      getCategoryFavorite() {
    return _remoteDataSource.getFavoriteCategory();
  }

  @override
  Future<Either<Failure, DoctorInfoEntity>> getDoctorInfo() {
    return _remoteDataSource.getDoctorInfo();
  }

  @override
  Future<Either<Failure, bool>> cancelAppointment(String id) {
    return _remoteDataSource.cancelAppointment(id);
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getBooking({required GetBookingParams params}) {
    return _remoteDataSource.getBooking(params:params);
  }

  @override
  Future<Either<Failure, List<MostBookingEntity>>> getMostBooking({required GetMostBookingParams params}) {
    return _remoteDataSource.getMostBooking(params:params);
  }
}
