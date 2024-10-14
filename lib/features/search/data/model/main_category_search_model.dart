import 'package:fourtyninehub/features/search/domain/entity/main_category_search_entity.dart';

class MainSubCategorySearchModel extends MainSubCategorySearchEntity {
  MainSubCategorySearchModel(
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
      required super.isFavorite,
      required super.enableInstallmentAndAuction});

  factory MainSubCategorySearchModel.fromJson(Map<String, dynamic> json) {
      return MainSubCategorySearchModel(
          id: json['_id'] ??'',
          banner: json['banner'] ?? json['picture'],
          cover: json['cover'] ??'',
          index: json['index'] ??0,
          createdAt: DateTime.parse(json['createdAt']),
          updatedAt: DateTime.parse(json['updatedAt']),
          nameAr: json['nameAr'] ??'',
          nameEn: json['nameEn'] ??'',
          nameCode: json['nameCode'] ??'',
          isHidden: json['isHidden'] ??false,
          enableInstallmentAndAuction: json['EnableInstallmentAndAuction'] ??false,
          isFavorite: json['isFavorite'] ??false,
      );
  }
}
