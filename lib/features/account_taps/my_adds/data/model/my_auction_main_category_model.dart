import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/my_auction_main_category.dart';

class MyAuctionMainCategoryModel extends MyAuctionMainCategory {
  MyAuctionMainCategoryModel(
      {required super.id,
      required super.banner,
      required super.cover,
      required super.index,
      required super.createdAt,
      required super.updatedAt,
      required super.nameAr,
      required super.nameEn,
      required super.nameCode,
      required super.isHidden,
      required super.enableInstallmentAndAuction});

  factory MyAuctionMainCategoryModel.fromJson(Map<String, dynamic> json) {
    return MyAuctionMainCategoryModel(
      id: json['_id'] ?? '',
      banner: json['banner'] ?? '',
      cover: json['cover'] ?? '',
      index: json['index'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      nameCode: json['nameCode'] ?? '',
      isHidden: json['isHidden'] ?? false,
      enableInstallmentAndAuction: json['EnableInstallmentAndAuction'] ?? false,
    );
  }
}
