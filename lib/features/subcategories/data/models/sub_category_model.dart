import '../../../../common/functions/helper/lang_helper.dart';
import '../../domain/entities/sub_category_entity.dart';

class SubCategoryModel extends SubCategoryEntity {
  SubCategoryModel(
      {required super.id,
      required super.name,
      required super.image,
      required super.isFavorite});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'],
      name: getLang() == 'ar' ? json['nameAr'] : json['nameEn'],
      image: json['picture'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['isFavorite'] = isFavorite;

    return data;
  }
}
