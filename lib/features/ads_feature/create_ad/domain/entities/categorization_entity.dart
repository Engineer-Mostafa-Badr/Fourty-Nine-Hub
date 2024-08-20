import '../../../../fourty_nine/domain/entities/main_category_entity.dart';

import '../../../../subcategories/domain/entities/sub_category_entity.dart';

class CategorizationEntity {
  final MainCategoryEntity mainCategory;
  final SubCategoryEntity subCategory;
  CategorizationEntity({required this.mainCategory, required this.subCategory});
}
