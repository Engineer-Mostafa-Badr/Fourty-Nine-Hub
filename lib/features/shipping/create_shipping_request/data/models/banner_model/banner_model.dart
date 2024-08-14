import 'main_category.dart';
import 'sub_category.dart';

class BannerModel {
  MainCategory? mainCategory;
  List<SubCategory>? subCategories;

  BannerModel({this.mainCategory, this.subCategories});

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        mainCategory: json['mainCategory'] == null
            ? null
            : MainCategory.fromJson(
                json['mainCategory'] as Map<String, dynamic>),
        subCategories: (json['subCategories'] as List<dynamic>?)
            ?.map((e) => SubCategory.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'mainCategory': mainCategory?.toJson(),
        'subCategories': subCategories?.map((e) => e.toJson()).toList(),
      };
}
