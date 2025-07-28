
import '../../domain/entities/food_ads_entity.dart';

class FoodAdModel extends FoodAdEntity {
  FoodAdModel({
    super.adId,
    AddressModel? super.address,
    super.views,
    SubCategoryModel? super.subCategory,
    MainCategoryModel? super.mainCategory,
    super.title,
    super.desc,
    List<ImageModel>? super.images,
    super.isPremium,
    super.phone,
    super.totalRating,
  });

  factory FoodAdModel.fromJson(Map<String, dynamic> json) {
    return FoodAdModel(
      adId: json['adId'],
      address: json['address'] != null ? AddressModel.fromJson(json['address']) : null,
      views: json['views'],
      subCategory: json['subCategory'] != null ? SubCategoryModel.fromJson(json['subCategory']) : null,
      mainCategory: json['mainCategory'] != null ? MainCategoryModel.fromJson(json['mainCategory']) : null,
      title: json['title'],
      desc: json['desc'],
      images: (json['images'] as List?)?.map((e) => ImageModel.fromJson(e)).toList(),
      isPremium: json['isPremium'],
      phone: json['phone'],
      totalRating: json['totalRating'],
    );
  }

}

class AddressModel extends FoodAdsAddressEntity {
  AddressModel({super.type, super.coordinates});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      type: json['type'],
      coordinates: (json['coordinates'] as List?)?.map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}

class SubCategoryModel extends FoodAdsSubCategoryEntity {
  SubCategoryModel({super.id, super.nameAr, super.nameEn});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
    };
  }
}

class MainCategoryModel extends FoodAdsMainCategoryEntity {
  MainCategoryModel({super.id, super.nameAr, super.nameEn});

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) {
    return MainCategoryModel(
      id: json['id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
    };
  }
}

class ImageModel extends FoodAdsImageEntity {
  ImageModel({
    super.fileName,
    super.id,
    super.user,
    super.subcategoryId,
    super.mimetype,
    super.size,
    super.mediaKey,
    super.successUpload,
    super.createdAt,
    super.updatedAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      fileName: json['fileName'],
      id: json['_id'],
      user: json['user'],
      subcategoryId: json['subcategoryId'],
      mimetype: json['mimetype'],
      size: json['size'],
      mediaKey: json['mediaKey'],
      successUpload: json['successUpload'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

}


