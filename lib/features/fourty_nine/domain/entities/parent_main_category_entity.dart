import 'package:equatable/equatable.dart';

import 'main_category_entity.dart';

class ParentMainCategoryEntity extends Equatable {
  final String id;
  final String nameAr;
  final String nameEn;
  final List<MainCategoryEntity> mainCategories;

  const ParentMainCategoryEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.mainCategories,
  });

  @override
  List<Object?> get props => [
        id,
        nameAr,
        nameEn,
        mainCategories,
      ];
}
