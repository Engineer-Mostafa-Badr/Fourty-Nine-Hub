import '../../domain/entities/main_category_entity.dart';

class MainCategoryModel extends MainCategoryEntity {
  const MainCategoryModel({
    required super.id,
    required super.name,
    required super.image,
    required super.banner,
    required super.cover,
    required super.isFavorite,
    required super.total,
  });

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) =>
      MainCategoryModel(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        banner: json['banner'],
        cover: json['cover'],
        isFavorite: json['is_favorite'] == true,
        total: json['total'] ?? 0,
      );
}
