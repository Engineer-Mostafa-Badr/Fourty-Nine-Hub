import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';

class AdPropertiesEntity {
  final String id;
  final String nameAr;
  final String nameEn;
  final String type;
  final List<SelectionEntity> values;
  final String? subCategoryId;
  final String? mainCategoryId;
  AdPropertyType get adPropertyType => getAdPropertyTypeValue(type);
  AdPropertiesEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.type,
    required this.values,
    this.subCategoryId,
    this.mainCategoryId,
  });

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'type': type,
      'values': values,
    };
  }
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
