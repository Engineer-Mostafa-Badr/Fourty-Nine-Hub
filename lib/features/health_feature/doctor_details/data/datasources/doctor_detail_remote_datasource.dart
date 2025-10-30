import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';

import 'package:fourtyninehub/features/health_feature/doctor_details/data/models/doctor_model.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/data/models/user_doctor_rate.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/user_doctor_rate.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/add_doctor_rating_use_case.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_details_Id_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_details_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_reviews.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/appointment_entity.dart';

import '../../../../../core/error/failure.dart';

abstract class DoctorDetailsRemoteDataSource {
  Future<Either<Failure, DoctorEntity>> getDoctorDetails(
      GetDoctorDetailsParams params);
  Future<Either<Failure, DoctorEntity>> getDoctorDetailsId(
      GetDoctorDetailsIdParams params);
  // New: booking doctor details by id
  Future<Either<Failure, DoctorEntity>> getBookingDoctorById(
      {required String doctorId});

  Future<Either<Failure, List<UserDoctorRateEntity>>> getDoctorReviews(
      GetUserDoctorRatesParams params);
  Future<Either<Failure, List<UserDoctorRateEntity>>> getDoctorRatings(
      PaginationParams params);

  Future<Either<Failure, bool>> addDoctorRating(AddDoctorRatingParams params);

  // New: booking doctor availabilities
  Future<Either<Failure, List<AppointmentEntity>>> getDoctorAvailabilities(
      {required String doctorId, int page = 1, int limit = 100});
}

class DoctorDetailsRemoteDataSourceImpl
    implements DoctorDetailsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  DoctorDetailsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, DoctorEntity>> getDoctorDetails(
      GetDoctorDetailsParams params) async {
    print("objectDoctorParams${params.toJson()}");
    final response = await _apiConsumer.get(
        EndPoints.getDoctorDetails(params.doctorId),
        data: params.toJson());
    return response.fold((failure) => Left(failure),
        (data) => Right(DoctorModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, List<UserDoctorRateEntity>>> getDoctorReviews(
      GetUserDoctorRatesParams params) async {
    final response = await _apiConsumer.get(
        EndPoints.getDoctorReviewsForUsers(params.doctorId),
        queryParameters: params.toJson());
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(
        List<UserDoctorRateEntity>.from(
          (data['data'] as List).map((e) => UserDoctorRateModel.fromJson(e)),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, List<UserDoctorRateEntity>>> getDoctorRatings(
      PaginationParams params) async {
    final response = await _apiConsumer.get(EndPoints.getDoctorReviews,
        queryParameters: params.toJson());
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(
        List<UserDoctorRateEntity>.from(
          (data['data'] as List).map((e) => UserDoctorRateModel.fromJson(e)),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, DoctorEntity>> getDoctorDetailsId(
      GetDoctorDetailsIdParams params) async {
    final response = await _apiConsumer
        .get(EndPoints.getDoctorDetailsId(params), data: params.toJson());
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(DoctorModel.fromJson(data['data'])),
    );
  }

  @override
  Future<Either<Failure, DoctorEntity>> getBookingDoctorById(
      {required String doctorId}) async {
    final response =
        await _apiConsumer.get(EndPoints.getBookingDoctorById(doctorId));
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(DoctorModel.fromJson(data['data'] ?? data)),
    );
  }

  @override
  Future<Either<Failure, bool>> addDoctorRating(
      AddDoctorRatingParams params) async {
    final response = await _apiConsumer.post(
        EndPoints.getDoctorReviewsForUsers(params.doctorId),
        data: params.toJson());
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(data['status'] ?? false),
    );
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getDoctorAvailabilities(
      {required String doctorId, int page = 1, int limit = 100}) async {
    final response = await _apiConsumer.get(
      EndPoints.getBookingDoctorAvailabilities(doctorId,
          page: page, limit: limit),
    );

    return response.fold(
      (failure) => Left(failure),
      (data) {
        try {
          final List availabilities =
              (data['data']?['availabilities'] ?? []) as List;

          final List<AppointmentEntity> mapped = [];
          for (final item in availabilities) {
            final detection = item['detection'] as Map<String, dynamic>? ?? {};
            final String detectionType = (detection['type'] ?? '').toString();
            final String appointmentType = detectionType == 'video_call'
                ? 'calls'
                : detectionType == 'home_visit'
                    ? 'visitHome'
                    : 'clinic';
            final List slots = item['slots'] as List? ?? [];
            for (int i = 0; i < slots.length; i++) {
              final s = slots[i] as Map<String, dynamic>;
              mapped.add(
                AppointmentEntity(
                  id: (detection['_id'] ?? '') + '_$i',
                  day: (s['dayOfWeek'] ?? '').toString(),
                  startTime: (s['startTime'] ?? '').toString(),
                  endTime: (s['endTime'] ?? '').toString(),
                  appointmentType: appointmentType,
                  dateOfDay: '',
                  isExpired: false,
                  status: AppointmentStatus.pending,
                ),
              );
            }
          }

          return Right(mapped);
        } catch (e) {
          return const Right(<AppointmentEntity>[]);
        }
      },
    );
  }
}
