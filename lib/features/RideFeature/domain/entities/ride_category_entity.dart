import 'package:fourtyninehub/features/RideFeature/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/sub_category_entity.dart';

class RideCategoryEntityUpdated {
  final MainCategoryEntityUpdated mainCategory;
  final List<SubCategoryEntityUpdated> subCategories;

  RideCategoryEntityUpdated({
    required this.mainCategory,
    required this.subCategories,
  });
}