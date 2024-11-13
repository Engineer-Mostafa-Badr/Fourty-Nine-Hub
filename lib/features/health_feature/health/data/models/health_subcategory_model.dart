import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';

class HealthSubcategoryModel extends HealthSubcategoryEntity {
  HealthSubcategoryModel(
      {required super.id,
      required super.nameAr,
      required super.nameEn,
      required super.image,
      required super.isFavorite,
      required super.numberOfContent});

  factory HealthSubcategoryModel.fromJson(Map<String, dynamic> json) {
    return HealthSubcategoryModel(
        id: json['_id'],
        nameAr:json['nameAr'] ,
        nameEn:  json['nameEn'],
        image: json['picture'] ?? '',
        isFavorite: json['isFavorite'] ?? false,
        numberOfContent: json['numberOfAds']);
  }
}
