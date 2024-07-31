import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/user_doctor_rate.dart';

import '../../../../../core/error/failure.dart';
import '../entities/doctor_entity.dart';

abstract class DoctorDetailsRepo {
  Future<Either<Failure, DoctorEntity>> getDoctorDetails(String doctorId);
  Future<Either<Failure, List<UserDoctorRateEntity>>> getDoctorReviews(
      String doctorId);
}
