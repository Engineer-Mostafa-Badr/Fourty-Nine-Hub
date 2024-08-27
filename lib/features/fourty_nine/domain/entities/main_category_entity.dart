import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/res/style/const.dart';

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


  factory MainCategoryEntity.fake(){
    return  const MainCategoryEntity(id: "id",
        name: "Fake Data",
        image: UIConst.imagePlaceHolder,
        banner: UIConst.imagePlaceHolder,
        cover: UIConst.imagePlaceHolder,
        isFavorite: false,
        total: 9900000
    );
  }


  @override
  List<Object?> get props =>
      [
        id,
        name,
        image,
        banner,
        cover,
        isFavorite,
        total,
      ];
}
