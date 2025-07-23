import 'category_id.dart';

class FavouriteCategoryModel {
String? id;
CategoryId? categoryId;


  FavouriteCategoryModel({
    this.id,
    this.categoryId,

  });

  factory FavouriteCategoryModel.fromJson(Map<String, dynamic> json) {
return FavouriteCategoryModel(
  id: json['_id'] as String?,
  categoryId: json['mainCategoryDetails'] == null
      ? null
      : CategoryId.fromJson(json['mainCategoryDetails'] as Map<String, dynamic>),

);
  }

}
