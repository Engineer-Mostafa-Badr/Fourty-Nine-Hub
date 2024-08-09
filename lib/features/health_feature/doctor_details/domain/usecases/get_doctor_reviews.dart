import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/user_doctor_rate.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/repositories/doctor_details_repo.dart';

class GetUserDoctorRatessUseCase
    extends UseCase<List<UserDoctorRateEntity>, String> {
  final DoctorDetailsRepo repo;

  GetUserDoctorRatessUseCase(this.repo);
  @override
  Future<Either<Failure, List<UserDoctorRateEntity>>> call(String params) {
    return repo.getDoctorReviews(params);
  }
}
