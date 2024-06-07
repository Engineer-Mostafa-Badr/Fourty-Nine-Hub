import 'package:equatable/equatable.dart';

import 'main_category_entity.dart';

class ParentMainCategoryEntity extends Equatable {
  final int id;
  final String name;
  final String image;
  final List<MainCategoryEntity> mainCategories;

  const ParentMainCategoryEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.mainCategories,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        mainCategories,
      ];
}
