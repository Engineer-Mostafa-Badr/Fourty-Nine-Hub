import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/sub_category_entity.dart';

class SubCategoryModel extends SubCategoryEntity {
  const SubCategoryModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.pictureUrl,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      pictureUrl: json['pictureUrl'],
    );
  }
}
