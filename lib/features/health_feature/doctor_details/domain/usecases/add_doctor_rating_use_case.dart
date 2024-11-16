import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/user_doctor_rate.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/repositories/doctor_details_repo.dart';

class AddDoctorRatingUseCase
    extends UseCase<bool, AddDoctorRatingParams> {
  final DoctorDetailsRepo repo;

  AddDoctorRatingUseCase(this.repo);
  @override
  Future<Either<Failure, bool>> call(AddDoctorRatingParams params) {
    return repo.addDoctorRating(params);
  }
}

class AddDoctorRatingParams{
  final String doctorId;
  final int rating;
  final String comment;
  final String phone;

  AddDoctorRatingParams({required this.doctorId, required this.rating, required this.comment, required this.phone});

  //toJson
  Map<String, dynamic> toJson() => {'rate': rating, 'comment': comment, 'phone': phone};
}