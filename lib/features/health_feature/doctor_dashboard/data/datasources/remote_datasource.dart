import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/data/models/doctor_appointment_model.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/data/models/doctor_statistics_model.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/data/models/doctor_work_days_model.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_statistics_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_work_days_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_appointments_by_day.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_id_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_personal_info_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_timetable_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/data/models/doctor_model.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';

abstract class DoctorDashboardRemoteDataSource {
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

  Future<Either<Failure, bool>> deleteAccount(String doctorId);

  Future<Either<Failure, bool>> updateID(DoctorDocsParams params);

  Future<Either<Failure, bool>> updatePersonalInfo(
      DoctorPersonalInfoParams params);

  Future<Either<Failure, bool>> updatePracticingCirtificate(
      DoctorDocsParams params);

  Future<Either<Failure, bool>> updateProfilePhoto(String photoId);

  Future<Either<Failure, bool>> updateTimetable(DoctorTimetableParams params);
  Future<Either<Failure, DoctorWorkDaysEntity>> getWorkDays();
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
      data: params.toJson(),
      queryParameters: params.paginationParams.toJson(),
    );
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data'] as List)
            .map((e) => DoctorAppointmentModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>>
      getDoctorUnhandledAppointments(PaginationParams params) async {
    final response = await _apiConsumer.get(
        EndPoints.getDoctorUnhandledAppointments,
        queryParameters: params.toJson());
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

  @override
  Future<Either<Failure, List<DoctorAppointmentEntity>>> getAllReservations(
      PaginationParams params) async {
    final response = await _apiConsumer.get(EndPoints.getAllDoctorReservations,
        queryParameters: params.toJson());

    return response.fold((failure) => Left(failure), (data) {
      return Right((data['data']['reservations'] as List)
          .map((e) => DoctorAppointmentModel.fromJson(e))
          .toList());
    });
  }

  @override
  Future<Either<Failure, DoctorEntity>> getDoctorProfile() async {
    final response = await _apiConsumer.get(EndPoints.getDoctorProfile);
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(DoctorModel.fromJson(data['data'])),
    );
  }

  @override
  Future<Either<Failure, bool>> deleteAccount(String doctorId) async {
    final response =
        await _apiConsumer.delete(EndPoints.deleteDoctor(doctorId));

    return response.fold((l) => Left(l), (r) => Right(r['status'] as bool));
  }

  @override
  Future<Either<Failure, bool>> updateID(DoctorDocsParams params) async {
    print("objectPArams ${params.toJson()}");
    final response = await _apiConsumer.post(
      EndPoints.updateDoctorID,
      data: params.toJson(),
    );

    return response.fold((l) => Left(l), (r) => Right(r['status'] as bool));
  }

  @override
  Future<Either<Failure, bool>> updatePersonalInfo(
      DoctorPersonalInfoParams params) async {
    print("objectPArams ${params.toJson()}");
    final response = await _apiConsumer.put(
      EndPoints.createDoctor,
      data: params.toJson(),
    );

    return response.fold((l) => Left(l), (r) => Right(r['status'] as bool));
  }

  @override
  Future<Either<Failure, bool>> updatePracticingCirtificate(
      DoctorDocsParams params) async {
    final response = await _apiConsumer.post(
      EndPoints.updateDoctorPractcing,
      data: params.toJson(),
    );

    return response.fold((l) => Left(l), (r) => Right(r['status'] as bool));
  }

  @override
  Future<Either<Failure, bool>> updateProfilePhoto(String photoId) async {
    final response = await _apiConsumer
        .put(EndPoints.updateDoctorProfilePhoto, data: {'mediaId': photoId});

    return response.fold((l) => Left(l), (r) => Right(r['status'] as bool));
  }

  @override
  Future<Either<Failure, bool>> updateTimetable(DoctorTimetableParams params) {
    // TODO: implement updateTimetable
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, DoctorWorkDaysEntity>> getWorkDays() async {
    final response = await _apiConsumer.get(EndPoints.getDoctorWorkDays);
    return response.fold(
          (failure) => Left(failure),
          (data) => Right(DoctorWorkDaysModel.fromJson(data['data'])),
    );
  }
}
