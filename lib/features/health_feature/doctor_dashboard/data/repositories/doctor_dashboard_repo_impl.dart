import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';

import '../../domain/repositories/doctor_dashboard_repo.dart';
import '../datasources/doctor_dashboard_remote_datasource.dart';

class DoctorDashboardRepoImpl implements DoctorDashboardRepo {
  final DoctorDashboardRemoteDataSource _remoteDataSource;
  DoctorDashboardRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, bool>> cancelBooking({required int id}) async {
    return await _remoteDataSource.cancelBooking(id: id);
  }

  @override
  Future<Either<Failure, bool>> changeActiveStatus(
      {required bool status}) async {
    return await _remoteDataSource.changeActiveStatus(status: status);
  }

  @override
  Future<Either<Failure, bool>> confirmBooking({required int id}) async {
    return await _remoteDataSource.confirmBooking(id: id);
  }

  @override
  Future<Either<Failure, List<BookedAppointmentEntity>>>
      getDoctorBookings() async {
    return await _remoteDataSource.getDoctorBookings();
  }
}
