import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/repositories/doctor_details_repo.dart';
import '../../../../../../core/abstract/use_case.dart';

class GetDoctorDetailsUseCase
    extends UseCase<DoctorEntity, int> {
  final DoctorDetailsRepo _repo;
  GetDoctorDetailsUseCase(this._repo);

  @override
  Future<Either<Failure, DoctorEntity>> call(int params) {
    return  _repo.getDoctorDetails(id: params);
  }
}
