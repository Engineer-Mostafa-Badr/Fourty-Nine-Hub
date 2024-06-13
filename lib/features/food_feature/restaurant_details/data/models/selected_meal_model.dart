import 'package:fourtyninehub/features/food_feature/restaurant_details/data/models/meal_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/data/models/option_model.dart';

import '../../domain/entities/selected_meal_entity.dart';
import 'selected_variation_model.dart';

class SelectedMealModel extends SelectedMealEntity {
  SelectedMealModel(
      {required super.qty,
      required super.price,
      required super.meal,
      required super.selectedAddOn,
      required super.selectedVariations});

  factory SelectedMealModel.fromJson(Map<String, dynamic> json) {
    return SelectedMealModel(
      qty: json['qty'],
      price: json['price'],
      meal: MealModel.fromJson(json['meal']),
      selectedAddOn: (json['selected_addon'] as List)
          .map((e) => OptionModel.fromJson(e))
          .toList(),
      selectedVariations: (json['selected_variation'] as List)
          .map((e) => SelectedVariationModel.fromJson(e))
          .toList(),
    );
  }
}
