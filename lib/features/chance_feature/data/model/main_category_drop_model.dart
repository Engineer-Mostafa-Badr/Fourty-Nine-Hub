import 'package:fourtyninehub/features/chance_feature/domain/entity/main_category_drop_entity.dart';

class MainCategoryDropModel extends MainCategoryDropEntity {
  MainCategoryDropModel({
    required super.id,
    required super.banner,
    required super.cover,
    required super.index,
    required super.nameAr,
    required super.nameEn,
    required super.isFavorite,
    required super.numberOfAdsCount,
  });

  factory MainCategoryDropModel.fromJson(Map<String, dynamic> json) {
    return MainCategoryDropModel(
      id: json['_id'] ?? '',
      banner: json['banner'] ?? '',
      cover: json['cover'] ?? ' ',
      index: json['index'] ?? 0 ,
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
      numberOfAdsCount: json['numberOfAdsCount'] ?? 0,
    );
  }
}
