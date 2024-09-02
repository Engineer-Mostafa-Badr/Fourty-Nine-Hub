import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/favorite_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';

class FavoriteCategoryModel extends FavoriteCategoryBannersEntity {
  FavoriteCategoryModel(
      {required super.id, required super.banner, required super.cover, required super.name});

  factory FavoriteCategoryModel.fromJson(Map<String, dynamic> json) {
    return FavoriteCategoryModel(
       id:json["_id"],
      banner: json['banner'],
      cover: json['cover'],
      name: getLang() == 'ar' ? json['nameAr'] : json['nameEn'],
    );
  }
}
