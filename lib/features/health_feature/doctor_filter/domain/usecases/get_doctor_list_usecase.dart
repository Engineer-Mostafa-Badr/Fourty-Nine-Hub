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

class GetDoctorListUseCase
    extends UseCase<List<DoctorEntity>, DoctorSearchParams> {
  final DoctorListRepo _repo;
  GetDoctorListUseCase(this._repo);

  @override
  Future<Either<Failure, List<DoctorEntity>>> call(DoctorSearchParams params) {
    return _repo.getDoctorsList(params: params);
  }
}

class DoctorSearchParams {
  GovernorateEntity governorate =
      GovernorateEntity(id: '', nameEn: '', nameAr: '');
  CityEntity city = CityEntity(id: '', nameEn: '', nameAr: '');
  SubCategoryEntity subCategory = SubCategoryEntity(
    id: '',
    nameAr: '',
    nameEn: '',
    image: '',
    isFavorite: false,
  );
  BookingTypes? bookingType;
  PaginationParams paginationParams = PaginationParams(page: 1);
  DoctorSearchParams();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subCategoryId'] = subCategory.id;
    if (bookingType != null) {
      data['type'] = bookingType?.name == 'home'
          ? 'visitHome'
          : bookingType?.name == 'call'
              ? 'calls'
              : 'clinic';
      if (bookingType != BookingTypes.call) {
        data['governorateId'] = governorate.id;
        data['cityId'] = city.id;
      }
    }

    return data;
  }
}
