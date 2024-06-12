import '../../domain/entities/meal_entity.dart';
import 'option_model.dart';
import 'variation_model.dart';

class MealModel extends MealEntity {
  MealModel(
      {required super.id,
      required super.name,
      required super.description,
      required super.image,
      required super.price,
      required super.variations,
      required super.addOns, required super.oldPrice});
  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      oldPrice: json['oldPrice']=0,
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
