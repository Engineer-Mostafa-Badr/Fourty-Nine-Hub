import 'package:fourtyninehub/features/ads_feature/create_ad/data/models/selection_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';

class AdPropertyModel extends AdPropertiesEntity {
  AdPropertyModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.type,
    required super.values,
    super.subCategoryId,
    super.mainCategoryId,
  });
  factory AdPropertyModel.fromJson(Map<String, dynamic> json) {
    return AdPropertyModel(
      id: json['propId']??json['_id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      type: json['type'],
      subCategoryId: json['sub_category_id'],
      mainCategoryId: json['main_category_id'],
      values: json['selections'] == null
          ? []
          : (json['selections'] as List)
              .map((e) => SelectionModel.fromJson(e))
              .toList(),
    );
  }
}
