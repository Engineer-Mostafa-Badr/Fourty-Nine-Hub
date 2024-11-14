import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/repositories/doctor_list_repo.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
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


