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
    // Replace specific Arabic text
    String nameAr = json['nameAr'];
    if (nameAr == 'معمل اسنان') {
      nameAr = 'عياده أسنان';
    }

    return HealthSubcategoryModel(
        id: json['id'] ?? json['_id'],
        nameAr: nameAr,
        nameEn: json['nameEn'],
        image: json['pictureUrl'] ?? json['picture'] ?? '',
        isFavorite: json['isFavorite'] ?? false,
        numberOfContent: json['numberOfAds'] ?? 0);
  }
}
