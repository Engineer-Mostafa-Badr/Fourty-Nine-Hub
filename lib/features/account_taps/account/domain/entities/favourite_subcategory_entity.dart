import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

class FavouriteSubcategoryEntity {
  final int id;

  final SubCategoryEntity item;
  FavouriteSubcategoryEntity({
    required this.id, 
    required this.item
  });
}
