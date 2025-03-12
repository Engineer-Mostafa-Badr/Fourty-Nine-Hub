
import 'package:fourtyninehub/features/RideFeature/domain/entities/main_category_entity.dart';

class MainCategoryModelUpdated extends MainCategoryEntityUpdated {
  MainCategoryModelUpdated({
    required super.mainCategoryId,
    required super.nameAr,
    required super.nameEn,
    required super.banner,
    required super.cover,
    required super.isFavorite,
    required super.registeredSubcategory,
    required super.isDriver,
    required super.isSocketCategory,
    required super.isDriverApproved,
    required super.driverLength,
  });

  factory MainCategoryModelUpdated.fromJson(Map<String, dynamic> json) {
    return MainCategoryModelUpdated(
      mainCategoryId: json['mainCategoryId'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      banner: json['banner'] ?? '',
      cover: json['cover'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
      registeredSubcategory: json['registeredSubcategory']??'',
      isDriver: json['isDriver'] ?? false,
      isSocketCategory: json['isSocketCategory'],
      isDriverApproved: json['isDriverApproved'] ?? false,
      driverLength: json['driverLength'] ?? 0,
    );
  }
}
