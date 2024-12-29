import '../../../../common/functions/helper/lang_helper.dart';
import '../../domain/entities/sub_category_entity.dart';

class SubCategoryModel extends SubCategoryEntity {
  SubCategoryModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.image,
    super.numberOfContent,
    super.hasAuction,
    required super.isFavorite,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    // Check for id, nameAr, and nameEn at top level and in subCategoryId
    final subCategoryData = json['subCategoryId'] is Map
        ? json['subCategoryId'] as Map<String, dynamic>
        : null;

    return SubCategoryModel(
      id: subCategoryData?['_id'] ?? json['_id'] ?? '',
      nameAr: json['nameAr'] ?? subCategoryData?['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? subCategoryData?['nameEn'] ?? '',
      numberOfContent: json['numberOfAdsCount'] ?? 0,
      image: json['picture'] ?? subCategoryData?['picture'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
      hasAuction: json['has_auction'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = getLang() == 'en' ? nameEn : nameAr;
    if (numberOfContent != null) {
      data['numberOfAdsCount'] = numberOfContent;
    }
    data['image'] = image;
    data['isFavorite'] = isFavorite;

    return data;
  }
}
