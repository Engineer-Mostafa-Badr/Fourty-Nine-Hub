import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/data/datasources/remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_appointments_by_day.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_unhandled_appointments_usecase.dart';

class DoctorDashboardRepoImpl implements DoctorDashboardRepo {
  final DoctorDashboardRemoteDataSource remoteDataSource;
  DoctorDashboardRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, int>> getIDRemainingDays() {
    return remoteDataSource.getIDRemainingDays();
  }

  @override
  Future<Either<Failure, int>> getPracticingRemainingDays() {
    return remoteDataSource.getPracticingRemainingDays();
  }

  @override
  Future<Either<Failure, int>> getSubscriptionRemainingDays() {
    return remoteDataSource.getSubscriptionRemainingDays();
  }

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>> getDoctorAppointmentsByDay(GetDoctorAppointmentsByDayParams params) {
    return remoteDataSource.getDoctorAppointmentsByDay(params);
  }

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>> getDoctorUnhandledAppointments(GetDoctorUnhandledAppointmentsParams params) {
    return remoteDataSource.getDoctorUnhandledAppointments(params);
  }
  
  @override
  Future<Either<Failure, bool>> acceptAppointment(String appointmentId) {
    return remoteDataSource.acceptAppointment(appointmentId);
  }
  
  @override
  Future<Either<Failure, bool>> rejectAppointment(String appointmentId) {
    return remoteDataSource.rejectAppointment(appointmentId);
  }

  
}
