import 'package:dartz/dartz.dart';
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
      GovernorateEntity(id: '', nameAr: '', nameEn: '');
  CityEntity city = CityEntity(id: '', nameAr: '', nameEn: '');
  SubCategoryEntity subCategory =
      SubCategoryEntity(id: '', name: '', image: '', isFavorite: false);
  BookingTypes bookingType = BookingTypes.call;
  DoctorSearchParams();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['governorateId'] = governorate.id;
    data['cityId'] = city.id;
    data['subCategoryId'] = subCategory.id;
    data['type'] = bookingType.name;
    return data;
  }

  void reset() {
    governorate = GovernorateEntity(id: '', nameAr: '', nameEn: '');
    city = CityEntity(id: '', nameAr: '', nameEn: '');
    subCategory =
        SubCategoryEntity(id: '', name: '', image: '', isFavorite: false);
    bookingType = BookingTypes.call;
  }
}
