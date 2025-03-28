import 'package:fourtyninehub/features/custom_page/domain/entity/favourite_categ_entity.dart';

import '../../domain/entity/custom_page_categories_entity.dart';

class CustomPageCategoriesModel extends CustomPageCategoriesEntity {
   CustomPageCategoriesModel({
    required super.nameEn,
    required super.nameAr,
    required super.enabled,
    required super.banner,
    super.selected
  });

  factory CustomPageCategoriesModel.fromJson(Map<String, dynamic> json) {
    return CustomPageCategoriesModel(
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      enabled: json['selected'],
      banner: json['banner'],
    );
  }
}
