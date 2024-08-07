import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_statistics_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_appointments_by_day.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_unhandled_appointments_usecase.dart';

abstract class DoctorDashboardRepo {
  Future<Either<Failure, int>> getPracticingRemainingDays();
  Future<Either<Failure, int>> getIDRemainingDays();
  Future<Either<Failure, int>> getSubscriptionRemainingDays();
  Future<Either<Failure, List<DoctorAppointmentEntity>>>
      getDoctorAppointmentsByDay(GetDoctorAppointmentsByDayParams params);
  Future<Either<Failure, List<DoctorAppointmentEntity>>>
      getDoctorUnhandledAppointments(
          GetDoctorUnhandledAppointmentsParams params);

  Future<Either<Failure, bool>> acceptAppointment(String appointmentId);
  Future<Either<Failure, bool>> rejectAppointment(String appointmentId);

  Future<Either<Failure, DoctorStatisticsEntity>> getDoctorStatistics();
}
