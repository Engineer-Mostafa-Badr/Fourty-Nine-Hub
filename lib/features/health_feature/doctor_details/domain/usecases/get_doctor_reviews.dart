import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/user_doctor_rate.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/repositories/doctor_details_repo.dart';

class GetUserDoctorRatessUseCase
    extends UseCase<List<UserDoctorRateEntity>, GetUserDoctorRatesParams> {
  final DoctorDetailsRepo repo;

  GetUserDoctorRatessUseCase(this.repo);
  @override
  Future<Either<Failure, List<UserDoctorRateEntity>>> call(GetUserDoctorRatesParams params) {
    return repo.getDoctorReviews(params);
  }
}

class GetUserDoctorRatesParams{
  final String doctorId;
  final int page;
  final int limit;
  GetUserDoctorRatesParams({required this.doctorId,required this.page,required this.limit});
  //toJson
  Map<String,dynamic> toJson(){
    return {
      'page':page,
      'limit':limit
    };
  }
}