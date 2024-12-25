import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/user_doctor_rate.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/add_doctor_rating_use_case.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_details_Id_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_details_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_reviews.dart';

import '../../../../../core/error/failure.dart';
import '../entities/doctor_entity.dart';

abstract class DoctorDetailsRepo {
  Future<Either<Failure, DoctorEntity>> getDoctorDetails(
      GetDoctorDetailsParams params);
  Future<Either<Failure, DoctorEntity>> getDoctorDetailsId(
      GetDoctorDetailsIdParams params);
  Future<Either<Failure, List<UserDoctorRateEntity>>> getDoctorReviews(
      GetUserDoctorRatesParams params);
  Future<Either<Failure, List<UserDoctorRateEntity>>> getDoctorRatings(
      PaginationParams params);
  Future<Either<Failure, bool>> addDoctorRating(AddDoctorRatingParams params);
}
