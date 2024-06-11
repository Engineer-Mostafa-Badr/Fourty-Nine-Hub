import 'package:fourtyninehub/features/food/restaurant_details/data/models/meal_model.dart';
import 'package:fourtyninehub/features/food/restaurant_details/data/models/option_model.dart';

class SelectedMealEntity {
  int qty;
  double price;
  List<OptionModel> selectedVariations;
  List<OptionModel> selectedAddOn;
  MealModel meal;
  SelectedMealEntity({
    required this.qty,
    required this.price,
    required this.meal,
    required this.selectedAddOn, 
    required this.selectedVariations,
  });
}
