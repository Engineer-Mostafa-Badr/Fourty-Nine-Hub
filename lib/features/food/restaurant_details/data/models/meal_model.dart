import 'package:fourtyninehub/features/food/restaurant_details/data/models/option_model.dart';
import 'package:fourtyninehub/features/food/restaurant_details/data/models/variation_model.dart';
import 'package:fourtyninehub/features/food/restaurant_details/domain/entities/meal_entity.dart';

class MealModel extends MealEntity {
  MealModel(
      {required super.id,
      required super.name,
      required super.description,
      required super.image,
      required super.price,
      required super.variations,
      required super.addOns});
  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      variations: (json['variations'] as List)
          .map((e) => VariationModel.fromJson(e))
          .toList(),
      addOns: (json['add_ons'] as List)
          .map((e) => OptionModel.fromJson(e))
          .toList(),
    );
  }
}
