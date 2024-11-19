import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/props_ads_entity.dart';

class PropsAdsModel extends PropsAdsEntity {
  PropsAdsModel(
      {required super.id,
    //  required super.propertyDetails,
      required super.adsId,
      required super.value,
      required super.createdAt,
      required super.updatedAt});

  factory PropsAdsModel.fromJson(Map<String, dynamic> json) {
    return PropsAdsModel(
      id: json['_id'],
     // propertyDetails: PropertyDetailsModel.fromJson(json['propertyId']),
      adsId: json['adsId'],
      value: PropertyValueModel.fromJson(json['value']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class PropertyDetailsModel extends PropertyDetailsEntity {
  PropertyDetailsModel(
      {required super.id,
      required super.mainCategoryId,
      required super.nameAr,
      required super.nameEn,
      required super.index,
      required super.type,
      required super.createdAt,
      required super.updatedAt});

  factory PropertyDetailsModel.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsModel(
      id: json['_id'],
      mainCategoryId: json['main_category_id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      index: json['index'],
      type: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class PropertyValueModel extends PropertyValueEntity {
  PropertyValueModel({required super.ar, required super.en, required super.id});

  factory PropertyValueModel.fromJson(Map<String, dynamic> json) {
    return PropertyValueModel(
      ar: json['ar'],
      en: json['en'],
      id: json['_id'],
    );
  }
}
