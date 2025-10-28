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
      id: json['propertyId'] != null && json['propertyId'] is Map
          ? json['propertyId']['_id'] ?? ''
          : '',
      nameAr: json['propertyId'] != null && json['propertyId'] is Map
          ? json['propertyId']['name_ar'] ?? json['name_ar'] ?? ''
          : json['name_ar'] ?? '',
      nameEn: json['propertyId'] != null && json['propertyId'] is Map
          ? json['propertyId']['name_en'] ?? json['name_en'] ?? ''
          : json['name_en'] ?? '',
      valueAr: json['value'] != null && json['value'] is Map
          ? json['value']['ar'] ?? json['ar'] ?? ''
          : json['ar'] ?? '',
      valueEn: json['value'] != null && json['value'] is Map
          ? json['value']['en'] ?? json['en'] ?? ''
          : json['en'] ?? '',
      imageUrl: json['propertyId'] != null && json['propertyId'] is Map
          ? json['propertyId']['image'] ?? ''
          : '',
    );
  }
}
