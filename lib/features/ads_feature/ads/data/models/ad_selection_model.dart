import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_selection_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/data/models/selection_model.dart';

class AdSelectionModel extends AdSelectionEntity {
  AdSelectionModel(
      {required super.value, super.propId});
  factory AdSelectionModel.fromJson(Map<String, dynamic> json) {
    return AdSelectionModel(
      value: SelectionModel.fromJson(json['value']),
      // propId: json['propertyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value.toJson(),
      // 'propertyId': propId,
    };
  }
}
