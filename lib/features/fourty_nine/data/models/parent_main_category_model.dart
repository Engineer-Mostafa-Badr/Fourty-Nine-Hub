import 'package:fourtyninehub/features/fourty_nine/data/models/main_category_model.dart';

import '../../domain/entities/parent_main_category_entity.dart';

class ParentMainCategoryModel extends ParentMainCategoryEntity {
  const ParentMainCategoryModel({
    required super.id,
    required super.name,
    required super.image,
    required super.mainCategories,
  });

  factory ParentMainCategoryModel.fromJson(Map<String, dynamic> json) =>
      ParentMainCategoryModel(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        mainCategories: (json['main_categories'] as List)
            .map((e) => MainCategoryModel.fromJson(e))
            .toList(),
      );
}
