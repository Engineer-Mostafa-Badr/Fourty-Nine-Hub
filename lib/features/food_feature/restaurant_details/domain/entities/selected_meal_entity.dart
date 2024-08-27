import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/entities/meal_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';

import 'option_entity.dart';
import 'variation_entity.dart';

class SelectedMealEntity {
  int qty;
  double price;
  String restaurantId;
  List<SelectedVariationEntity> selectedVariations;
  List<OptionEntity> selectedAddOn;
  RestaurantMenu meal;
  SelectedMealEntity({
    required this.qty,
    required this.price,
    required this.restaurantId,
    required this.meal,
    required this.selectedAddOn,
    required this.selectedVariations,
  });
}

class SelectedVariationEntity {
  VariationEntity variation;
  OptionEntity selectedOption;
  SelectedVariationEntity({
    required this.selectedOption,
    required this.variation,
  });
}
