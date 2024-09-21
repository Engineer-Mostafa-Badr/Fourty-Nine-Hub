import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/res/style/const.dart';

import '../../../subcategories/domain/entities/sub_category_entity.dart';

class MainCategoryEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  List<SubCategoryEntity>? subcategories;
  final String banner;
  final String cover;
  bool? isFavorite;
  final int total;
  final String? favoriteName;

  MainCategoryEntity({
    required this.id,
    required this.name,
    required this.image,
    this.subcategories,
    required this.banner,
    required this.cover,
    this.isFavorite = false,
    required this.total,
    this.favoriteName,
  });

  factory MainCategoryEntity.fake() {
    return MainCategoryEntity(
        id: "id",
        name: "Fake Data",
        image: UIConst.imagePlaceHolder,
        banner: UIConst.imagePlaceHolder,
        cover: UIConst.imagePlaceHolder,
        isFavorite: false,
        total: 9900000);
  }

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
