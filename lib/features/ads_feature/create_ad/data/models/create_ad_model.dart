import 'package:fourtyninehub/features/ads_feature/create_ad/data/models/selection_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';

class CreateAdModel extends CreateAdEntity {
  CreateAdModel({required super.value, required super.propId,super.nameAr,super.nameEn});
  factory CreateAdModel.fromJson(Map<String, dynamic> json) {
    return CreateAdModel(
      value: SelectionModel.fromJson(json['value']),
      propId: json['propertyId'] is String? json['propertyId']: json['propertyId']['_id'] ?? '',
      nameAr: json['propertyId'] is String? '': json['propertyId']['name_ar']??'',
      nameEn: json['propertyId'] is String? '': json['propertyId']['name_en']??'',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'value': value.toJson(),
      'propertyId': propId,
      'nameAr': nameAr,
      'nameEn': nameEn
    };
  }
}
