import '../../domain/entities/food_category_entity.dart';

class FoodCategoryModel extends FoodCategoryEntity {
  FoodCategoryModel({required super.id, required super.name, required super.image});
  factory FoodCategoryModel.fromJson(Map<String, dynamic> json) {
    return FoodCategoryModel(
      id: json['id'],
      name:json['name'],
      image: json['image']
    );
  }
}
