
import '../../data/models/meal_model.dart';
import 'option_entity.dart';
import 'variation_entity.dart';

class SelectedMealEntity {
  int qty;
  num price;
  List<SelectedVariationEntity> selectedVariations;
  List<OptionEntity> selectedAddOn;
  MealModel meal;
  SelectedMealEntity({
    required this.qty,
    required this.price,
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
