
import '../../domain/entities/food_ads_entity.dart';

class FoodAdModel extends FoodAdEntity {
  FoodAdModel({
    String? adId,
    AddressModel? address,
    int? views,
    SubCategoryModel? subCategory,
    MainCategoryModel? mainCategory,
    String? title,
    String? desc,
    List<ImageModel>? images,
    bool? isPremium,
    String? phone,
    int? totalRating,
  }) : super(
    adId: adId,
    address: address,
    views: views,
    subCategory: subCategory,
    mainCategory: mainCategory,
    title: title,
    desc: desc,
    images: images,
    isPremium: isPremium,
    phone: phone,
    totalRating: totalRating,
  );

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
  AddressModel({String? type, List<double>? coordinates})
      : super(type: type, coordinates: coordinates);

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
  SubCategoryModel({String? id, String? nameAr, String? nameEn})
      : super(id: id, nameAr: nameAr, nameEn: nameEn);

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
  MainCategoryModel({String? id, String? nameAr, String? nameEn})
      : super(id: id, nameAr: nameAr, nameEn: nameEn);

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
    String? fileName,
    String? id,
    String? user,
    String? subcategoryId,
    String? mimetype,
    int? size,
    String? mediaKey,
    bool? successUpload,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
    fileName: fileName,
    id: id,
    user: user,
    subcategoryId: subcategoryId,
    mimetype: mimetype,
    size: size,
    mediaKey: mediaKey,
    successUpload: successUpload,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

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


