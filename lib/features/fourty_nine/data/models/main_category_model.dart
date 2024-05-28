import '../../domain/entities/main_category_entity.dart';

class MainCategoryModel extends MainCategoryEntity {
  const MainCategoryModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.banner,
    required super.cover,
    required super.isFavorite,
    required super.total,
  });

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) =>
      MainCategoryModel(
        id: json['_id'],
        nameAr: json['name_ar'] ?? json['name'],
        nameEn: json['name_en'] ?? json['name'],
        banner: json['banner'],
        cover: json['cover'],
        isFavorite: json['is_favorite'] == true,
        total: json['total'] ?? 0,
      );
}
