import 'package:fourtyninehub/features/chance_feature/domain/entity/main_categry_entity.dart';

class MainCategoryModel extends MainCategoryEntity {
  MainCategoryModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.nameCode,
  });

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) {
    return MainCategoryModel(
      id: json['_id'] ?? "",
      nameAr: json['nameAr'] ?? "",
      nameEn: json['nameEn'] ?? "",
      nameCode: json['nameCode'] ?? "",
    );
  }
}
