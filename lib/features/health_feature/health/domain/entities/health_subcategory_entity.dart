import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

class HealthSubcategoryEntity extends SubCategoryEntity {
  final int numberOfDoctors;
  HealthSubcategoryEntity({
    required super.id,
    required super.name,
    required super.image,
    required super.isFavourite,
    required this.numberOfDoctors,
  });
}
