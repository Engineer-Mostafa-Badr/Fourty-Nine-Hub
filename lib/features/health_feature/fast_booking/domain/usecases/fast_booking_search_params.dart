import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/city_entity.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

class FastBookingSearchParams {
  int page = 1;
  int limit = 10;
  String type = '';
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
  FastBookingSearchParams();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subCategoryId'] = subCategory.id;
    if (bookingType != null) {
      data['type'] = bookingType?.name == 'home'
          ? 'visitHome'
          : bookingType?.name == 'videoCall'
              ? 'calls'
              : 'clinic';
      // Video calls don't require location, but clinic and home visits do
      if (bookingType != BookingTypes.videoCall) {
        data['governorateId'] = governorate.id;
        data['cityId'] = city.id;
      }
    }
    return data;
  }
}
