import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';

import '../../../../res/style/const.dart';
import '../../domain/entities/main_category_entity.dart';

class MainCategoryModel extends MainCategoryEntity {
  MainCategoryModel({
    required super.id,
    required super.name,
    required super.image,
    super.nameEn,
    required super.banner,
    required super.cover,
    required super.isFavorite,
    required super.total,
     super.numberOfAdsCount,
    super.subcategories,
  });

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) =>
      MainCategoryModel(
          id: json['_id'],
          name: getLang() == 'ar' ? json['nameAr'] : json['nameEn'],
          nameEn: json['nameEn'],
          image: json['image'] ?? UIConst.imagePlaceHolder,
          banner: json['banner'] ?? '',
          cover: json['cover'] ?? '',
          isFavorite: json['isFavorite'] ?? false,
          total: json['totalAds'] ?? 0,
          numberOfAdsCount: json['numberOfAdsCount'] ?? 0,
          total: json['numberOfAdsCount'] ?? 0,
          subcategories: json['subCategories'] == null
              ? []
              : (json['subCategories'] as List)
                  .map((e) => SubCategoryModel.fromJson(e))
                  .toList());
}
