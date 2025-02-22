import 'package:fourtyninehub/features/RideFeature/data/models/ride_main_category.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_sub_category.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_category_entity.dart';

class RideCategoryModelUpdated extends RideCategoryEntityUpdated {
  RideCategoryModelUpdated({
    required MainCategoryModelUpdated mainCategory,
    required List<SubCategoryModelUpdated> subCategories,
  }) : super(mainCategory: mainCategory, subCategories: subCategories);

  factory RideCategoryModelUpdated.fromJson(Map<String, dynamic> json) {
    return RideCategoryModelUpdated(
      mainCategory: MainCategoryModelUpdated.fromJson(json['mainCategory']),
      subCategories: (json['subCategories'] as List)
          .map((e) => SubCategoryModelUpdated.fromJson(e))
          .toList(),
    );
  }
}
