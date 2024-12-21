import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/repositories/doctor_list_repo.dart';
import '../../../../../../core/abstract/use_case.dart';

class GetSubCategoryDoctorsListUseCase
    extends UseCase<List<DoctorEntity>, GetSubCategoryDoctorsParams> {
  final DoctorListRepo _repo;
  GetSubCategoryDoctorsListUseCase(this._repo);

  @override
  Future<Either<Failure, List<DoctorEntity>>> call(GetSubCategoryDoctorsParams params) {
    return _repo.getSubCategoryDoctorsList(params: params);
  }
}

class GetSubCategoryDoctorsParams extends PaginationParams {
  final String subCategoryId;
  GetSubCategoryDoctorsParams({required this.subCategoryId, required super.page, required super.limit});

  @override
  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit};
}
