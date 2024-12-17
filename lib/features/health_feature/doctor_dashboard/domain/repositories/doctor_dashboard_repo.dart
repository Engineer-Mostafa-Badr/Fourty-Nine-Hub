import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_statistics_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_work_days_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_appointments_by_day.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_id_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_personal_info_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_timetable_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';

abstract class DoctorDashboardRepo {
  Future<Either<Failure, int>> getPracticingRemainingDays();
  Future<Either<Failure, int>> getIDRemainingDays();
  Future<Either<Failure, int>> getSubscriptionRemainingDays();
  Future<Either<Failure, List<DoctorAppointmentEntity>>>
      getDoctorAppointmentsByDay(GetDoctorAppointmentsByDayParams params);
  Future<Either<Failure, List<DoctorAppointmentEntity>>>
      getDoctorUnhandledAppointments(PaginationParams params);

  Future<Either<Failure, bool>> acceptAppointment(String appointmentId);
  Future<Either<Failure, bool>> rejectAppointment(String appointmentId);

  Future<Either<Failure, DoctorStatisticsEntity>> getDoctorStatistics();

  Future<Either<Failure, List<DoctorAppointmentEntity>>> getAllReservations(
      PaginationParams params);

  Future<Either<Failure, DoctorEntity>> getDoctorProfile();

  Future<Either<Failure, bool>> updateProfilePhoto(String photoId);
  Future<Either<Failure, bool>> updateID(DoctorDocsParams params);
  Future<Either<Failure, bool>> updatePracticingCirtificate(
      DoctorDocsParams params);
  Future<Either<Failure, bool>> deleteAccount(String doctorId);
  Future<Either<Failure, DoctorWorkDaysEntity>> getWorkDays();
  Future<Either<Failure, bool>> updatePersonalInfo(
      DoctorPersonalInfoParams params);
  Future<Either<Failure, bool>> updateTimetable(DoctorTimetableParams params);
}
