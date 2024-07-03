import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';

class FavouriteCategoryEntity {
  final int id;

  final MainCategoryEntity item;
  FavouriteCategoryEntity({
    required this.id, 
    required this.item
  });
}
