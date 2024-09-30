import '../../domain/entities/favourite_category_entity.dart';

class FavouriteCategoryModel extends FavouriteCategoryEntity {
  FavouriteCategoryModel({
    required super.id,
    required super.numberOfAds,
    required super.banner,
    required super.cover,
    required super.isFavorite,
    required super.name,
  });

  factory FavouriteCategoryModel.fromJson(Map<String, dynamic> json) {
    return FavouriteCategoryModel(
      id: json['id'] as String,
      banner: json['banner'] as String,
      name: json['user_id'] as String,
      cover: json['createdAt'] as String,
      isFavorite: json['updatedAt'] as bool,
      numberOfAds: json['numberOfAds'] as int,
    );
  }
}
