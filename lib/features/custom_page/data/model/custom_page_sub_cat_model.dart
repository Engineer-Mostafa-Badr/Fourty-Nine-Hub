import 'package:fourtyninehub/features/custom_page/domain/entity/favourite_categ_entity.dart';

import '../../domain/entity/custom_page_categories_entity.dart';
import '../../domain/entity/custom_page_sub_categories_entity.dart';

class CustomPageSubCategoriesModel extends CustomPageSubCategoriesEntity {
   CustomPageSubCategoriesModel({
     required super.id,
    required super.nameEn,
    required super.nameAr,
    required super.enabled,
    required super.picture,
    super.selected,
  });

  factory CustomPageSubCategoriesModel.fromJson(Map<String, dynamic> json) {
    return CustomPageSubCategoriesModel(
      id: json['_id'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      enabled: json['selected'],
      picture: json['picture'],
    );
  }
}
