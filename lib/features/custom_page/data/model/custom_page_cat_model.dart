import '../../domain/entity/custom_page_categories_entity.dart';

class CustomPageCategoriesModel extends CustomPageCategoriesEntity {
  CustomPageCategoriesModel({
    required super.id,
    required super.nameEn,
    required super.nameAr,
    required super.enabled,
    required super.banner,
    required super.subCategories,
    super.selected,
  });

  factory CustomPageCategoriesModel.fromJson(Map<String, dynamic> json) {
    return CustomPageCategoriesModel(
      id: json['_id'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      enabled: json['selected'],
      banner: json['banner'],
      subCategories: json['subCategories'].cast<String>(),
    );
  }
}
