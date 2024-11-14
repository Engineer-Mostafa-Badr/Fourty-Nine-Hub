import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';

import 'package:fourtyninehub/features/health_feature/doctor_details/data/models/doctor_model.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/data/models/user_doctor_rate.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/user_doctor_rate.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/add_doctor_rating_use_case.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_details_Id_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_details_usecase.dart';

import '../../../../../core/error/failure.dart';

abstract class DoctorDetailsRemoteDataSource {
  Future<Either<Failure, DoctorEntity>> getDoctorDetails(
      GetDoctorDetailsParams params);
  Future<Either<Failure, DoctorEntity>> getDoctorDetailsId(
      GetDoctorDetailsIdParams params);

  Future<Either<Failure, List<UserDoctorRateEntity>>> getDoctorReviews(
      String doctorId);
  Future<Either<Failure, List<UserDoctorRateEntity>>> getDoctorRatings();

  Future<Either<Failure, bool>>addDoctorRating(AddDoctorRatingParams params);
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
      String doctorId) async {
    final response =
        await _apiConsumer.get(EndPoints.getDoctorReviewsForUsers(doctorId));
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
  Future<Either<Failure, List<UserDoctorRateEntity>>> getDoctorRatings() async {
    final response =
        await _apiConsumer.get(EndPoints.getDoctorReviews);
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
  Future<Either<Failure, DoctorEntity>> getDoctorDetailsId(GetDoctorDetailsIdParams params) async {
    final response =
        await _apiConsumer.get(EndPoints.getDoctorDetailsId(params),data: params.toJson());
    return response.fold(
          (failure) => Left(failure),
          (data) => Right(
        DoctorModel.fromJson(data['data'])
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> addDoctorRating(AddDoctorRatingParams params) async {
    final response =
        await _apiConsumer.post(EndPoints.getDoctorReviewsForUsers(params.doctorId),
            data: params.toJson());
    return response.fold(
          (failure) => Left(failure),
          (data) => Right(
          data['status'] ?? false
      ),
    );
  }
}
