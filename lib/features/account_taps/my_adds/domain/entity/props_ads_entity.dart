class PropsAdsEntity {
  final String id;
  final PropertyDetailsEntity propertyDetails;
  final String adsId;
  final PropertyValueEntity value;
  final DateTime createdAt;
  final DateTime updatedAt;

  PropsAdsEntity(
      {required this.id,
      required this.propertyDetails,
      required this.adsId,
      required this.value,
      required this.createdAt,
      required this.updatedAt});

}

class PropertyDetailsEntity {
  final String id;
  final String mainCategoryId;
  final String nameAr;
  final String nameEn;
  final int index;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  PropertyDetailsEntity({
    required this.id,
    required this.mainCategoryId,
    required this.nameAr,
    required this.nameEn,
    required this.index,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyDetailsEntity.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsEntity(
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

class PropertyValueEntity {
  final String ar;
  final String en;
  final String id;

  PropertyValueEntity({
    required this.ar,
    required this.en,
    required this.id,
  });

  factory PropertyValueEntity.fromJson(Map<String, dynamic> json) {
    return PropertyValueEntity(
      ar: json['ar'],
      en: json['en'],
      id: json['_id'],
    );
  }
}
