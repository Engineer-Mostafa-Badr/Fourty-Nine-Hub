import 'package:fourtyninehub/features/ads_feature/create_ad/data/models/selection_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';

class CreateAdModel extends CreateAdEntity {
  CreateAdModel({required super.value, required super.propId});
  factory CreateAdModel.fromJson(Map<String, dynamic> json) {
    return CreateAdModel(
      value: SelectionModel.fromJson(json['value']),
      propId: json['propertyId'] != null ? json['propertyId'] : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value.toJson(),
      'propertyId': propId,
    };
  }
}
