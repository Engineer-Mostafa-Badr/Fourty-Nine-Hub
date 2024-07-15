import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';

import '../../../../res/style/const.dart';
import '../../domain/entities/main_category_entity.dart';

class MainCategoryModel extends MainCategoryEntity {
  const MainCategoryModel({
    required super.id,
    required super.name,
    required super.image,
    required super.banner,
    required super.cover,
    required super.isFavorite,
    required super.total,
  });

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) =>
      MainCategoryModel(
        id: json['_id'],
        name: getLang()=='ar'?json['nameAr']:json['nameEn'],
        image: json['image']??UIConst.imagePlaceHolder,
        banner: json['banner']??'',
        cover: json['cover']??'',
        isFavorite: json['is_favorite']??false,
        total: json['total'] ?? 0,
      );
}
