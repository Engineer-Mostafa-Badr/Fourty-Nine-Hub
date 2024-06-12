import 'package:fourtyninehub/features/food_feature/restaurant_details/data/models/variation_model.dart';

import '../../data/models/option_model.dart';

class MealEntity {
  final int id;
  final String name;
  final String description;
  final String image;
  final num price;
  final num oldPrice;
  final List<VariationModel> variations;
  final List<OptionModel> addOns;
  MealEntity(
      {required this.id,
      required this.name,
      required this.description,
      required this.image,
      required this.price,
      required this.oldPrice,
      required this.variations,
      required this.addOns});
}
