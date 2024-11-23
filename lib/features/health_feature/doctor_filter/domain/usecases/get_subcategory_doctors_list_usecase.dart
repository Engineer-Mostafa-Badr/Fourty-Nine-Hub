import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/repositories/doctor_list_repo.dart';
import '../../../../../../core/abstract/use_case.dart';

class GetSubCategoryDoctorsListUseCase
    extends UseCase<List<DoctorEntity>, String> {
  final DoctorListRepo _repo;
  GetSubCategoryDoctorsListUseCase(this._repo);

  @override
  Future<Either<Failure, List<DoctorEntity>>> call(String params) {
    return _repo.getSubCategoryDoctorsList(params: params);
  }
}
