import 'package:equatable/equatable.dart';

import '../../../subcategories/domain/entities/sub_category_entity.dart';

class MainCategoryEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final List<SubCategoryEntity>? subcategories;
  final String banner;
  final String cover;
  final bool isFavorite;
  final int total;

  const MainCategoryEntity({
    required this.id,
    required this.name,
    required this.image,
    this.subcategories,
    required this.banner,
    required this.cover,
    required this.isFavorite,
    required this.total,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        banner,
        cover,
        isFavorite,
        total,
      ];
}
