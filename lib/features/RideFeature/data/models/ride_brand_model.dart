import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_brand_entity.dart';

class RideBrandModel extends RideBrandEntity {
  RideBrandModel({required super.id, required super.brandNameAr, required super.brandNameEn, required super.logoUrl});

  factory RideBrandModel.fromJson(Map<String, dynamic> json) {
    return RideBrandModel(
        id: json['_id'] ?? '',
        brandNameAr: json['brandNameAr'] ?? '',
        brandNameEn: json['brandNameEn'] ?? '',
        logoUrl: json['logoUrl'] ?? '');
  }
}