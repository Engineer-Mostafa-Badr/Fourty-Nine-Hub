
import '../../domain/entities/selected_meal_entity.dart';

class SelectedMealModel extends SelectedMealEntity {
  SelectedMealModel(
      {required super.qty,
      required super.price,
      required super.meal,
      required super.restaurantId,
      required super.selectedAddOn,
      required super.selectedVariations});

  Map<String, dynamic> toJson() => {
        "restuarantId": restaurantId,
        "restaurantItems": [
          {
            "foodId": meal.id,
            "quantity": qty,
            "option": selectedVariations.first.selectedOption.id
          }
        ]
      };
}
