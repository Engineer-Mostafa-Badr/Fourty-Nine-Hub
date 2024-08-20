import '../../../../fourty_nine/data/models/main_category_model.dart';
import '../../domain/entities/favourite_category_entity.dart';

class FavouriteCategoryModel extends FavouriteCategoryEntity {
  FavouriteCategoryModel({required super.id, required super.item});

  factory FavouriteCategoryModel.fromJson(Map<String, dynamic> json) {
    return FavouriteCategoryModel(
      id: json['id'],
      item: MainCategoryModel.fromJson(json['item']),
    );
  }
}
