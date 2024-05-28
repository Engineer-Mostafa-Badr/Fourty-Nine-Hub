import 'package:fourtyninehub/features/fourty_nine/data/models/main_category_model.dart';

import '../../domain/entities/parent_main_category_entity.dart';

class ParentMainCategoryModel extends ParentMainCategoryEntity {
  const ParentMainCategoryModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.mainCategories,
  });

  factory ParentMainCategoryModel.fromJson(Map<String, dynamic> json) =>
      ParentMainCategoryModel(
        id: json['_id'],
        nameAr: json['name_ar'],
        nameEn: json['name_en'],
        mainCategories: (json['mainCategories'] as List)
            .map((e) => MainCategoryModel.fromJson(e))
            .toList(),
      );
}
