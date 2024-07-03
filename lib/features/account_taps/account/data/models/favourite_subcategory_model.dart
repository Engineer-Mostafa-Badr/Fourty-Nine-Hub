import '../../../../subcategories/data/models/sub_category_model.dart';
import '../../domain/entities/favourite_subcategory_entity.dart';

class FavouriteSubcategoryModel extends FavouriteSubcategoryEntity{
  FavouriteSubcategoryModel({required super.id, required super.item});

  factory FavouriteSubcategoryModel.fromJson(Map<String, dynamic> json) {
    return FavouriteSubcategoryModel(
      id: json['id'],
      item: SubCategoryModel.fromJson(json['item']),
      // id: json['id'],
    );
  }
}