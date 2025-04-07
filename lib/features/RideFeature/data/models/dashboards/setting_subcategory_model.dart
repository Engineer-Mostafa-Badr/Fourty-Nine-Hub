import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/setting_subcategory_entity.dart';

class SettingSubcategoryModel extends SettingSubcategoryEntity{
  SettingSubcategoryModel({required super.subcategoryId, required super.nameEn, required super.nameAr, required super.pictureKey, required super.isActive});

  //fromJson
  factory SettingSubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SettingSubcategoryModel(
      subcategoryId: json['subcategoryId']??'',
      nameEn: json['nameEn']??'',
      nameAr: json['nameAr']??'',
      pictureKey: json['pictureKey']??'',
      isActive: json['isActive']??false,
    );
  }
}