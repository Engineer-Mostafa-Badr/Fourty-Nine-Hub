import 'package:fourtyninehub/features/food_feature/restaurant_details/data/models/option_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/data/models/variation_model.dart';

import '../../domain/entities/selected_meal_entity.dart';

class SelectedVariationModel extends SelectedVariationEntity {
  SelectedVariationModel(
      {required super.selectedOption, required super.variation});

  factory SelectedVariationModel.fromJson(Map<String, dynamic> json) {
    return SelectedVariationModel(
        variation: VariationModel.fromJson(json['variation']),
        selectedOption: OptionModel.fromJson(json['selected_option']));
  }
}
