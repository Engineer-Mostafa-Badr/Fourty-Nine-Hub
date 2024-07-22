import '../../../../common/functions/helper/lang_helper.dart';
import '../../domain/entities/sub_category_entity.dart';

class SubCategoryModel extends SubCategoryEntity {
  SubCategoryModel(
      {required super.id,
      required super.name,
      required super.image,
      required super.isFavourite});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'],
      name: getLang() == 'ar' ? json['nameAr'] : json['nameEn'],
      image: json['picture']??'',
      isFavourite: json['is_favourite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['is_favourite'] = isFavourite;

    return data;
  }
}
