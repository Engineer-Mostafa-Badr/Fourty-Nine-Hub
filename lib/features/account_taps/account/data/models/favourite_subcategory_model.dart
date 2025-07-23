import '../../domain/entities/favourite_subcategory_entity.dart';

class FavouriteSubcategoryModel extends FavouriteSubcategoryEntity {
  FavouriteSubcategoryModel({
    required super.id,
    required super.idFavourite,
    required super.picture,
    required super.nameEn,
    required super.nameAr,
    required super.numOfAds,
  });

  factory FavouriteSubcategoryModel.fromJson(Map<String, dynamic> json) {
    return FavouriteSubcategoryModel(
      idFavourite: json['id'],
      id: json['subcategoryDetails']['id'],
      nameEn: json['subcategoryDetails']['nameEn'],
      nameAr: json['subcategoryDetails']['nameAr'],
      picture: json['subcategoryDetails']['picture'],
      numOfAds: json['subcategoryDetails']['numOfAds'],
    );
  }
}
