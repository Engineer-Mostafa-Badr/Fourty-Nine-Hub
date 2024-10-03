import '../../domain/entities/favourite_subcategory_entity.dart';

class FavouriteSubcategoryModel extends FavouriteSubcategoryEntity {
  FavouriteSubcategoryModel({
    required super.id,
    required super.picture,
    required super.nameEn,
    required super.nameAr,
    required super.numOfAds,
  });

  factory FavouriteSubcategoryModel.fromJson(Map<String, dynamic> json) {
    return FavouriteSubcategoryModel(
      id: json['subCategoryId']['_id'],
      nameEn: json['subCategoryId']['nameEn'],
      nameAr: json['subCategoryId']['nameAr'],
      picture: json['subCategoryId']['picture'],
      numOfAds: json['numOfAds'],
    );
  }
}