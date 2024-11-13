import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

class HealthSubcategoryEntity extends SubCategoryEntity {
  @override
  final int numberOfContent;
  HealthSubcategoryEntity({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.image,
    required super.isFavorite,
    required this.numberOfContent,
  });
}
