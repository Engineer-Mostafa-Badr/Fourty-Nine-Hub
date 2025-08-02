import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';

class FavouriteCategoryEntity {
  final String id;
  final MainCategoryEntity categoryEntity;

  FavouriteCategoryEntity({
    required this.id,
    required this.categoryEntity,
  });
}
