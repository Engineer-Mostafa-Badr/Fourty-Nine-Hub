import 'package:fourtyninehub/features/health_feature/shared/domain/entities/city_entity.dart';

class CityModel extends CityEntity {
  CityModel({required super.id, required super.nameAr, required super.nameEn});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] ?? json['_id'],
      nameAr: json['nameAr'] ?? json['city_name_ar'],
      nameEn: json['nameEn'] ?? json['city_name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['city_name_ar'] = nameAr;
    data['city_name_en'] = nameEn;
    return data;
  }
}
