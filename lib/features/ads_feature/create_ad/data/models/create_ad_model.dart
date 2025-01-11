import 'package:fourtyninehub/features/ads_feature/create_ad/data/models/selection_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';

class CreateAdModel extends CreateAdEntity {
  CreateAdModel({required super.value, required super.propId,super.nameAr,super.nameEn,super.image});
  factory CreateAdModel.fromJson(Map<String, dynamic> json) {
    return CreateAdModel(
      value: SelectionModel.fromJson(json['value']),
      propId: json['props'] is String? json['props']: json['_id'] ?? '',
      nameAr: json['props'] is String? '': json['value']['ar']??'',
      nameEn: json['props'] is String? '': json['value']['en']??'',
      image: json['propertyId'] is String? '': json['propertyId']['image']??'',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'value': value.toJson(),
      'props': propId,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'image': image
    };
  }
}
