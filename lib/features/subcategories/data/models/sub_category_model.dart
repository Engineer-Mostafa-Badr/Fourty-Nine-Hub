import '../../../../common/functions/helper/lang_helper.dart';
import '../../domain/entities/sub_category_entity.dart';

class SubCategoryModel extends SubCategoryEntity {
  SubCategoryModel(
      {required super.id,
      required super.name,
      required super.image,
      super.numberOfContent,
      required super.isFavorite});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'],
      name: getLang() == 'ar' ? json['nameAr'] : json['nameEn'],
      numberOfContent: json['numberOfAdsCount'] ?? 0,
      image: json['picture'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (numberOfContent != null) {
      data['numberOfAdsCount'] = numberOfContent;
    }
    data['image'] = image;
    data['isFavorite'] = isFavorite;

    return data;
  }
}
