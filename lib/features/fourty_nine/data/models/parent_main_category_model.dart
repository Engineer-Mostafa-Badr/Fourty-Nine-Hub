import '../../../../common/functions/helper/lang_helper.dart';
import 'main_category_model.dart';

import '../../../../res/style/const.dart';
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
        id: json['_id'],
        name: getLang() == 'ar' ? json['name_ar'] : json['name_en'],
        image: json['image'] ?? UIConst.imagePlaceHolder,
        mainCategories: (json['mainCategories'] as List)
            .map((e) => MainCategoryModel.fromJson(e))
            .toList(),
      );
}
