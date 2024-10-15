import '../../domain/entities/favourite_ad_drawer_entity.dart';

class FavouriteAdDrawerModel extends FavouriteAdDrawerEntity {
  FavouriteAdDrawerModel(
      {required super.id,
      required super.userId,
      required super.adId,
      required super.mainCategoryId,
      required super.nameEn,
      required super.nameAr,
      required super.title,
      required super.desc,
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
      userId: json['userId']['_id'] ?? '',
      adId: json['adId']['_id'] ?? '',
      mainCategoryId: json['adId']['mainCategoryId']['_id'] ?? '',
      nameEn: json['adId']['mainCategoryId']['nameEn'] ?? '',
      nameAr: json['adId']['mainCategoryId']['nameAr'] ?? '',
      title: json['adId']['title'] ?? '',
      desc: json['adId']['desc'] ?? '',
      images: (json['adId']['images'] as List)
          .map((e) => FavouriteAdDrawerImageModel.fromJson(e))
          .toList(),
      price: json['adId']['price'] ?? 0,
      phone: json['adId']['phone'] ?? '',
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
      id: json['id'] ??'',
      mediaKey: json['mediaKey'] ?? '',
    );
  }
}
