class PropsAdsEntity {
  final String id;
 // final PropertyDetailsEntity propertyDetails;
  final String adsId;
  final PropertyValueEntity value;
  final DateTime createdAt;
  final DateTime updatedAt;
  AdPropertyType get adPropertyType => getAdPropertyTypeValue('dropDown');

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

enum AdPropertyType { select, dropdown, number, text, image, file }

extension AdPropertyTypeX on AdPropertyType {
  bool get isSelect => this == AdPropertyType.select;
  bool get isDropDown => this == AdPropertyType.dropdown;
  bool get isNumber => this == AdPropertyType.number;
  bool get isText => this == AdPropertyType.text;
  bool get isImage => this == AdPropertyType.image;
  bool get isFile => this == AdPropertyType.file;
}

AdPropertyType getAdPropertyTypeValue(String type) {
  switch (type) {
    case 'number':
      return AdPropertyType.number;
    case 'select':
      return AdPropertyType.select;
    case 'dropDown':
      return AdPropertyType.dropdown;
    case 'textField':
      return AdPropertyType.text;
    case 'pictures':
      return AdPropertyType.image;
    case 'file':
      return AdPropertyType.file;
  }
  return AdPropertyType.text;
}
