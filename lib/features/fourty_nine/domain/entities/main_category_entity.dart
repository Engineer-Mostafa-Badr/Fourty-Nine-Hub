import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/res/style/const.dart';

import '../../../subcategories/domain/entities/sub_category_entity.dart';

class MainCategoryEntity extends Equatable {
  final String id;
  final String name;
  final String? nameEn;
  final String image;
  final List<SubCategoryEntity>? subcategories;
  final String banner;
  final String cover;
  final int? numberOfAdsCount;
  bool? isFavorite;
  final int total;

  MainCategoryEntity(
      {required this.id,
      required this.name,
      required this.nameEn,
      required this.image,
      this.subcategories,
      required this.banner,
      required this.cover,
      this.isFavorite = false,
      required this.total,
      this.numberOfAdsCount});

  factory MainCategoryEntity.fake() {
    return MainCategoryEntity(
        id: "id",
        name: "Fake Data",
        image: UIConst.imagePlaceHolder,
        banner: UIConst.imagePlaceHolder,
        cover: UIConst.imagePlaceHolder,
        isFavorite: false,
        total: 9900000,
        nameEn: '');
  }

  @override
  List<Object?> get props => [
        id,
        name,
        nameEn,
        image,
        banner,
        cover,
        isFavorite,
        total,
      ];
}
