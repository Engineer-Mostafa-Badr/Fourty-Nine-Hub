
// ======================= MODEL =========================
import '../../domain/entities/auction_sub_category_entity.dart';

class AuctionSubCategoryModel extends AuctionSubCategoryEntity {
  const AuctionSubCategoryModel({
    super.id,
    super.picture,
    super.nameAr,
    super.nameEn,
  });

  factory AuctionSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return AuctionSubCategoryModel(
      id: json['_id'] as String?,   // uses _id from response
      picture: json['picture'] as String?,
      nameAr: json['nameAr'] as String?,
      nameEn: json['nameEn'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'picture': picture,
      'nameAr': nameAr,
      'nameEn': nameEn,
    };
  }
}
