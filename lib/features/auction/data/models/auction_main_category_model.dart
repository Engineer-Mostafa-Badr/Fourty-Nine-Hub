
// ======================= MODEL =========================
import '../../domain/entities/auction_main_category_entity.dart';

class AuctionMainCategoryModel extends AuctionMainCategoryEntity {
  const AuctionMainCategoryModel({
    String? id,
    String? banner,
    String? cover,
    String? nameAr,
    String? nameEn,
  }) : super(
    id: id,
    banner: banner,
    cover: cover,
    nameAr: nameAr,
    nameEn: nameEn,
  );

  factory AuctionMainCategoryModel.fromJson(Map<String, dynamic> json) {
    return AuctionMainCategoryModel(
      id: json['id'] as String?,
      banner: json['banner'] as String?,
      cover: json['cover'] as String?,
      nameAr: json['nameAr'] as String?,
      nameEn: json['nameEn'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'banner': banner,
      'cover': cover,
      'nameAr': nameAr,
      'nameEn': nameEn,
    };
  }
}
