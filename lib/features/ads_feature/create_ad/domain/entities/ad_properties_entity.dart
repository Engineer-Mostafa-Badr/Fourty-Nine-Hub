class AdPropertiesEntity {
  final String label;
  final String type;
  final List<String> values;
  AdPropertyType get adPropertyType => getAdPropertyTypeValue(type);
  AdPropertiesEntity(
      {required this.label, required this.type, required this.values});
}

enum AdPropertyType { select, dropdown, number, text }

AdPropertyType getAdPropertyTypeValue(String type) {
  switch (type) {
    case 'number':
      return AdPropertyType.number;
    case 'select':
      return AdPropertyType.select;
    case 'dropdown':
      return AdPropertyType.dropdown;
    case 'text':
      return AdPropertyType.text;
  }
  return AdPropertyType.text;
}
