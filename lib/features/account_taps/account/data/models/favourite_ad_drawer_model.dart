import '../../domain/entities/favourite_ad_drawer_entity.dart';

class FavouriteAdDrawerModel extends FavouriteAdDrawerEntity {
  FavouriteAdDrawerModel(
      {required super.id,
      required super.userId,
      required super.mainCategoryId,
      required super.nameEn,
      required super.nameAr,
      required super.title,
      required super.desc,
      required super.subscriptionStatus,
      required super.images,
      required super.price,
      required super.phone,
      required super.subCategoryId,
      required super.subCategoryNameAr,
      required super.subCategoryNameEn,
      required super.createdAt});

  factory FavouriteAdDrawerModel.fromJson(Map<String, dynamic> json) {
    return FavouriteAdDrawerModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      mainCategoryId: json['mainCategoryId']['_id'] ?? '',
      nameEn: json['mainCategoryId']['nameEn'] ?? '',
      nameAr: json['mainCategoryId']['nameAr'] ?? '',
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      subscriptionStatus: json['subscriptionStatus'] ?? '',
      images: (json['images'] as List)
          .map((e) => FavouriteAdDrawerImageModel.fromJson(e))
          .toList(),
      price: json['price'] ?? 0,
      phone: json['phone'] ?? '',
      subCategoryId: json['subCategoryId']['_id'] ?? '',
      subCategoryNameAr: json['subCategoryId']['nameAr'] ?? '',
      subCategoryNameEn: json['subCategoryId']['nameEn'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class FavouriteAdDrawerImageModel extends FavouriteAdDrawerImages {
  FavouriteAdDrawerImageModel({required super.id, required super.mediaKey});

  factory FavouriteAdDrawerImageModel.fromJson(Map<String, dynamic> json) {
    return FavouriteAdDrawerImageModel(
      id: json['id'] ?? '',
      mediaKey: json['mediaKey'] ?? '',
    );
  }
}
