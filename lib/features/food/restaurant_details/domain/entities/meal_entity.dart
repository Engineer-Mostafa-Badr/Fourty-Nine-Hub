import 'option_entity.dart';
import 'variation_entity.dart';

class MealEntity {
  final int id;
  final String name;
  final String description;
  final String image;
  final num price;
  final List<VariationEntity> variations;
  final List<OptionEntity> addOns;
  MealEntity({
    required this.id, 
    required this.name, 
    required this.description, 
    required this.image, 
    required this.price, 
    required this.variations, 
    required this.addOns
  });
}
