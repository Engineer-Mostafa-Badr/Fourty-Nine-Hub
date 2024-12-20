import 'package:fourtyninehub/features/chance_feature/domain/entity/sub_category_drop_entity.dart';

class SubCategoryDropModel extends SubCategoryDropEntity {
  SubCategoryDropModel({
    required super.id,
    required super.parent,
    required super.picture,
    required super.hasAuction,
    required super.nameAr,
    required super.nameEn,
    required super.isFavorite,
    required super.numberOfAdsCount,
  });
  factory SubCategoryDropModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryDropModel(
      id: json['_id'] ?? '',
      parent: json['parent'] ?? '',
      picture: json['picture'] ?? '',
      hasAuction: json['has_auction'] ?? false,
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
      numberOfAdsCount: json['numberOfAdsCount'] ?? 0,
    );
  }
}
