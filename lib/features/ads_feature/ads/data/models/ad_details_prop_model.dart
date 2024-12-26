import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_details_prop_entity.dart';

class AdDetailsPropModel extends AdDetailsPropEntity {
  AdDetailsPropModel(
      {required super.nameAr,
      required super.nameEn,
      required super.valueAr,
      required super.valueEn});
  factory AdDetailsPropModel.fromJson(Map<String, dynamic> json) {
    return AdDetailsPropModel(
      nameAr: json['propertyId']?['name_ar'] ?? json['name_ar'] ?? '',
      nameEn: json['propertyId']?['name_en'] ?? json['name_ar'] ?? '',
      valueAr: json['value']?['ar'] ?? json['ar'] ?? '',
      valueEn: json['value']?['en'] ?? json['en'] ?? '',
    );
  }
}
