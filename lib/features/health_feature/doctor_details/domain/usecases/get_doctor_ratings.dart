import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/user_doctor_rate.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/repositories/doctor_details_repo.dart';

class GetDoctorReviewsUseCase
    extends UseCase<List<UserDoctorRateEntity>, NoParams> {
  final DoctorDetailsRepo repo;

  GetDoctorReviewsUseCase(this.repo);
  @override
  Future<Either<Failure, List<UserDoctorRateEntity>>> call(NoParams params) {
    return repo.getDoctorRatings();
  }
}
