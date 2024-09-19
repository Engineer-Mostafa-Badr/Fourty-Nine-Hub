class AdPropertiesEntity {
  final String label;
  final String type;
  final List<String> values;
  AdPropertyType get adPropertyType => getAdPropertyTypeValue(type);
  AdPropertiesEntity(
      {required this.label, required this.type, required this.values});
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
