import '../../domain/entities/favourite_category_entity.dart';

class FavouriteCategoryModel extends FavouriteCategoryEntity {
  FavouriteCategoryModel(
      {required super.id,
      required super.banner,
      required super.cover,
      required super.nameEn,
      required super.nameAr,
      required super.numberOfAds,
      super.isFavorite});

  factory FavouriteCategoryModel.fromJson(Map<String, dynamic> json) {
    return FavouriteCategoryModel(
      id: json['category_id'] != null ? json['category_id']['_id'] ?? '' : '',
      nameEn: json['category_id'] != null
          ? json['category_id']['nameEn'] ?? ''
          : '',
      nameAr: json['category_id'] != null
          ? json['category_id']['nameAr'] ?? ''
          : '',
      banner: json['category_id'] != null
          ? json['category_id']['banner'] ?? ''
          : '',
      cover:
          json['category_id'] != null ? json['category_id']['cover'] ?? '' : '',
      numberOfAds: json['category_id'] != null ? json['numberOfAds'] ?? 0 : 0,
    );
  }
}
