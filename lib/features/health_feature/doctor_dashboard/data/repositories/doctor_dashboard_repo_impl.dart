import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/data/datasources/remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_statistics_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_work_days_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_appointments_by_day.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_id_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_personal_info_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_timetable_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';

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
  Future<Either<Failure, List<DoctorAppointmentEntity>>>
      getDoctorAppointmentsByDay(GetDoctorAppointmentsByDayParams params) {
    return remoteDataSource.getDoctorAppointmentsByDay(params);
  }

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>>
      getDoctorUnhandledAppointments(PaginationParams params) {
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

  @override
  Future<Either<Failure, DoctorStatisticsEntity>> getDoctorStatistics() {
    return remoteDataSource.getDoctorStatistics();
  }

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>> getAllReservations(
      PaginationParams params) {
    return remoteDataSource.getAllReservations(params);
  }

  @override
  Future<Either<Failure, DoctorEntity>> getDoctorProfile() {
    return remoteDataSource.getDoctorProfile();
  }

  @override
  Future<Either<Failure, bool>> deleteAccount(String doctorId) {
    return remoteDataSource.deleteAccount(doctorId);
  }

  @override
  Future<Either<Failure, bool>> updateID(DoctorDocsParams params) {
    return remoteDataSource.updateID(params);
  }

  @override
  Future<Either<Failure, bool>> updatePersonalInfo(
      DoctorPersonalInfoParams params) {
    return remoteDataSource.updatePersonalInfo(params);
  }

  @override
  Future<Either<Failure, bool>> updatePracticingCirtificate(
      DoctorDocsParams params) {
    return remoteDataSource.updatePracticingCirtificate(params);
  }

  @override
  Future<Either<Failure, bool>> updateProfilePhoto(String photoId) {
    return remoteDataSource.updateProfilePhoto(photoId);
  }

  @override
  Future<Either<Failure, bool>> updateTimetable(DoctorTimetableParams params) {
    return remoteDataSource.updateTimetable(params);
  }

  @override
  Future<Either<Failure, DoctorWorkDaysEntity>> getWorkDays() {
    return remoteDataSource.getWorkDays();
  }
}
