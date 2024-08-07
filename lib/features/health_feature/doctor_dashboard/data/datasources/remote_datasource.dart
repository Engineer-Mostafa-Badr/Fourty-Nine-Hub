import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/data/models/doctor_appointment_model.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/data/models/doctor_statistics_model.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_statistics_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_appointments_by_day.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_unhandled_appointments_usecase.dart';

abstract class DoctorDashboardRemoteDataSource {
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

class DoctorDashboardRemoteDataSourceImpl
    implements DoctorDashboardRemoteDataSource {
  final ApiConsumer _apiConsumer;
  DoctorDashboardRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, int>> getPracticingRemainingDays() async {
    final response =
        await _apiConsumer.get(EndPoints.remainingDaysOfDoctorPracticing);

    return response.fold((l) => Left(l), (r) => Right(r['data'] as int));
  }

  @override
  Future<Either<Failure, int>> getIDRemainingDays() async {
    final response = await _apiConsumer.get(EndPoints.remainingDaysOfDoctorID);

    return response.fold((l) => Left(l), (r) => Right(r['data'] as int));
  }

  @override
  Future<Either<Failure, int>> getSubscriptionRemainingDays() async {
    final response =
        await _apiConsumer.get(EndPoints.remainingDaysOfDoctorSubscription);

    return response.fold((l) => Left(l), (r) => Right(r['data'] as int));
  }

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>>
      getDoctorAppointmentsByDay(
          GetDoctorAppointmentsByDayParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getDoctorAppointmentsByDay,
      data: params.toData(),
      queryParameters: params.toQueryParams(),
    );
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data'] as List)
            .map((e) => DoctorAppointmentModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>>
      getDoctorUnhandledAppointments(
          GetDoctorUnhandledAppointmentsParams params) async {
    final response = await _apiConsumer.get(
        EndPoints.getDoctorUnhandledAppointments,
        queryParameters: params.queryParams);
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data'] as List)
            .map((e) => DoctorAppointmentModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> acceptAppointment(String appointmentId) async {
    final response = await _apiConsumer
        .put(EndPoints.doctorAcceptAppointment(appointmentId));

    return response.fold((l) => Left(l), (r) => Right(r['status'] as bool));
  }

  @override
  Future<Either<Failure, bool>> rejectAppointment(String appointmentId) async {
    final response = await _apiConsumer
        .put(EndPoints.doctorRejectAppointment(appointmentId));

    return response.fold((l) => Left(l), (r) => Right(r['status'] as bool));
  }

  @override
  Future<Either<Failure, DoctorStatisticsEntity>> getDoctorStatistics() async {
    final response =
        await _apiConsumer.get(EndPoints.getDoctorTotalEarnedMoney);

    return response.fold((failure) => Left(failure), (data) {
      return Right(DoctorStatisticsModel.fromJson(data));
    });
  }
}
