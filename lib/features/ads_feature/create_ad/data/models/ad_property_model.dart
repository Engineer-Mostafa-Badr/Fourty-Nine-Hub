import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';

class AdPropertyModel extends AdPropertiesEntity {
  AdPropertyModel(
      {required super.label, required super.type, required super.values});
  factory AdPropertyModel.fromJson(Map<String, dynamic> json) {
    return AdPropertyModel(
      label: json['label'],
      type: json['type'],
      values: json['values'].cast<String>(),
    );
  }
}
