import 'package:fourtyninehub/features/food/restaurant_details/data/models/option_model.dart';
import 'package:fourtyninehub/features/food/restaurant_details/domain/entities/variation_entity.dart';

class VariationModel extends VariationEntity {
  VariationModel(
      {required super.id, required super.name, required super.options});
  factory VariationModel.fromJson(Map<String, dynamic> json) {
    return VariationModel(
      id: json['id'],
      name: json['name'],
      options: (json['options'] as List).map((e) => OptionModel.fromJson(e)).toList(),
    );
  }
}
