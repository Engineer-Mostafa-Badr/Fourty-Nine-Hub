import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../health/domain/entities/most_booking_entity.dart';
import '../repositories/doctor_list_repo.dart';


class GetDoctorListUseCase extends UseCase<List<MostBookingEntity> , GetDoctorListParams> {
  final DoctorListRepo _repo;

  GetDoctorListUseCase(this._repo);

  @override
  Future<Either<Failure, List<MostBookingEntity >>> call(GetDoctorListParams params) async {
    return await _repo.getDoctorsList(params: params);
  }
}
class GetDoctorListParams {
  final int page;
  final int limit;
  final String subCategoryId;

  GetDoctorListParams({
    required this.page,
    required this.limit,
    required this.subCategoryId,

  });
  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    // 'orderBy': orderBy,


  };
}