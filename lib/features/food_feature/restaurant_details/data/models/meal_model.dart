import '../../../../../common/functions/helper/lang_helper.dart';

import '../../domain/entities/meal_entity.dart';
import 'option_model.dart';
import 'variation_model.dart';

class MealModel extends MealEntity {
  MealModel(
      {required super.id,
      required super.name,
      required super.description,
      required super.pictures,
      required super.price,
      required super.variations,
      required super.addOns,
      required super.oldPrice});
  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'],
      name: getLang() == 'ar' ? json['name_ar'] : json['name_en'],
      description: json['desc'],
      price: json['price'],
      oldPrice: json['oldPrice'] = 0,
      pictures: (json['pictures'] as List)
          .map((e) => e['mediaKey'] as String)
          .toList(),
      variations: (json['ITEMS_VARIATIONS'] as List)
          .map((e) => VariationModel.fromJson(e))
          .toList(),
      addOns: json['add_ons'] == null
          ? []
          : (json['add_ons'] as List)
              .map((e) => OptionModel.fromJson(e))
              .toList(),
    );
  }
}
