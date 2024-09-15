import '../../domain/entities/favourite_subcategory_entity.dart';

class FavouriteSubcategoryModel extends FavouriteSubcategoryEntity {
  FavouriteSubcategoryModel(
      {required super.id, required super.picture, required super.name});

  factory FavouriteSubcategoryModel.fromJson(Map<String, dynamic> json) {
    return FavouriteSubcategoryModel(
      id: json['subCategoryId']['_id'],
      name: json['subCategoryId']['nameEn'],
      picture: json['subCategoryId']['picture'],
    );
  }
}
