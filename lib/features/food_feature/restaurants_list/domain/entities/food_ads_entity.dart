class FoodAdEntity {
  final String? adId;
  final FoodAdsAddressEntity? address;
  final int? views;
  final FoodAdsSubCategoryEntity? subCategory;
  final FoodAdsMainCategoryEntity? mainCategory;
  final String? title;
  final String? desc;
  final List<FoodAdsImageEntity>? images;
  final bool? isPremium;
  final String? phone;
  final int? totalRating;

  FoodAdEntity({
    this.adId,
    this.address,
    this.views,
    this.subCategory,
    this.mainCategory,
    this.title,
    this.desc,
    this.images,
    this.isPremium,
    this.phone,
    this.totalRating,
  });
}

class FoodAdsAddressEntity {
  final String? type;
  final List<double>? coordinates;

  FoodAdsAddressEntity({this.type, this.coordinates});
}

class FoodAdsSubCategoryEntity {
  final String? id;
  final String? nameAr;
  final String? nameEn;

  FoodAdsSubCategoryEntity({this.id, this.nameAr, this.nameEn});
}

class FoodAdsMainCategoryEntity {
  final String? id;
  final String? nameAr;
  final String? nameEn;

  FoodAdsMainCategoryEntity({this.id, this.nameAr, this.nameEn});
}

class FoodAdsImageEntity {
  final String? fileName;
  final String? id;
  final String? user;
  final String? subcategoryId;
  final String? mimetype;
  final int? size;
  final String? mediaKey;
  final bool? successUpload;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FoodAdsImageEntity({
    this.fileName,
    this.id,
    this.user,
    this.subcategoryId,
    this.mimetype,
    this.size,
    this.mediaKey,
    this.successUpload,
    this.createdAt,
    this.updatedAt,
  });
}

