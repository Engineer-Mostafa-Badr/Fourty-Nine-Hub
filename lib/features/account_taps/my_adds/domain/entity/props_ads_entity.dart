class PropsAdsEntity {
  final String id;
 // final PropertyDetailsEntity propertyDetails;
  final String adsId;
  final PropertyValueEntity value;
  final DateTime createdAt;
  final DateTime updatedAt;

  PropsAdsEntity(
      {required this.id,
   //   required this.propertyDetails,
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
}
