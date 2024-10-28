import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'food_category_model.g.dart';

@JsonSerializable()
class FoodCategoryModel extends FoodCategoryEntity {
  FoodCategoryModel({
    super.id,
    super.name,
    super.image,
    super.parent,
    super.picture,
    super.nameAr,
    super.nameEn,
    super.isFavorite,
    super.numberOfRestaurant,
  });

  factory FoodCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$FoodCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$FoodCategoryModelToJson(this);
}
