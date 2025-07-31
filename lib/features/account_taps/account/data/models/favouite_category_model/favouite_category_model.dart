
import '../../../../../fourty_nine/data/models/main_category_model.dart';
import '../../../domain/entities/favourite_category_entity.dart';

class FavouriteCategoryModel extends FavouriteCategoryEntity {
  FavouriteCategoryModel({
    required super.id,
    required super.categoryEntity,
  });

  factory FavouriteCategoryModel.fromJson(Map<String, dynamic> json) {
    return FavouriteCategoryModel(
      id: json['id'],
      categoryEntity: MainCategoryModel(
          id: json['mainCategoryDetails']['id'],
          name: json['mainCategoryDetails']['nameAr'],
          nameEn: json['mainCategoryDetails']['nameEn'],
          image: json['mainCategoryDetails']['coverUrl'],
          banner: json['mainCategoryDetails']['bannerUrl'],
          cover: json['mainCategoryDetails']['coverUrl'],
          isFavorite: true,
          total: 0,),
    );
  }
}
