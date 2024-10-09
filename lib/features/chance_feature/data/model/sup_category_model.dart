import 'package:fourtyninehub/features/chance_feature/domain/entity/sup_category_entity.dart';

class SupCategoryModel extends SubCategoryEntity {
  SupCategoryModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.nameCode,
  });

  factory SupCategoryModel.fromJson(Map<String, dynamic> json) {
    return SupCategoryModel(
      id: json['_id'] ?? "",
      nameAr: json['nameAr'] ?? "",
      nameEn: json['nameEn'] ?? "",
      nameCode: json['nameCode'] ?? "",
    );
  }
}
