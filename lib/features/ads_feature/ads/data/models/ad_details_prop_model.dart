import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_details_prop_entity.dart';

class AdDetailsPropModel extends AdDetailsPropEntity {
  AdDetailsPropModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.valueAr,
    required super.valueEn,
    required super.imageUrl,
  });
  factory AdDetailsPropModel.fromJson(Map<String, dynamic> json) {
    return AdDetailsPropModel(
      id: json['propertyId']?['_id'] ?? '',
      nameAr: json['propertyId']?['name_ar'] ?? json['name_ar'] ?? '',
      nameEn: json['propertyId']?['name_en'] ?? json['name_ar'] ?? '',
      valueAr: json['value']?['ar'] ?? json['ar'] ?? '',
      valueEn: json['value']?['en'] ?? json['en'] ?? '',
      imageUrl: json['propertyId']?['image'] ?? '',
    );
  }
}
