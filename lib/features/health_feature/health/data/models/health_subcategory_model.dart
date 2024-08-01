import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';

class HealthSubcategoryModel extends HealthSubcategoryEntity {
  HealthSubcategoryModel(
      {required super.id,
      required super.name,
      required super.image,
      required super.isFavourite,
      required super.numberOfDoctors});

  factory HealthSubcategoryModel.fromJson(Map<String, dynamic> json) {
    return HealthSubcategoryModel(
        id: json['_id'],
        name: getLang() == 'ar' ? json['nameAr'] : json['nameEn'],
        image: json['picture'] ?? '',
        isFavourite: json['is_favourite'] ?? false,
        numberOfDoctors: json['numberOfAds']);
  }
}
