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

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) {
    // Check for id, name, etc., in top-level and nested category_id
    final categoryData = json['category_id'] is Map
        ? json['category_id'] as Map<String, dynamic>
        : null;

    return MainCategoryModel(
      id: categoryData?['_id'] ?? json['_id'] ?? '',
      name: (getLang() == 'ar')
          ? (json['nameAr'] ?? categoryData?['nameAr'] ?? '')
          : (json['nameEn'] ?? categoryData?['nameEn'] ?? ''),
      nameEn: json['nameEn'] ?? categoryData?['nameEn'] ?? '',
      image:
          json['image'] ?? categoryData?['image'] ?? UIConst.imagePlaceHolder,
      banner: json['banner'] ?? categoryData?['banner'] ?? '',
      cover: json['cover'] ?? categoryData?['cover'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
      total: json['totalAds'] ?? 0,
      numberOfAdsCount: json['numberOfAdsCount'] ?? 0,
      subcategories: json['subCategories'] == null
          ? []
          : (json['subCategories'] as List)
              .map((e) => SubCategoryModel.fromJson(e))
              .toList(),
    );
  }
}
