import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/data/datasources/remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';

class DoctorDashboardRepoImpl implements DoctorDashboardRepo {
  final DoctorDashboardRemoteDataSource remoteDataSource;
  DoctorDashboardRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, int>> getIDRemainingDays(String doctorId) {
    return remoteDataSource.getIDRemainingDays(doctorId);
  }

  @override
  Future<Either<Failure, int>> getPracticingRemainingDays(String doctorId) {
    return remoteDataSource.getPracticingRemainingDays(doctorId);
  }

  @override
  Future<Either<Failure, int>> getSubscriptionRemainingDays(String doctorId) {
    return remoteDataSource.getSubscriptionRemainingDays(doctorId);
  }
}
