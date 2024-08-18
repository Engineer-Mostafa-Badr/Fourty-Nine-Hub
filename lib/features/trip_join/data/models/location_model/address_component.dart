import 'dart:convert';

class AddressComponent {
  String? longName;
  String? shortName;
  List<String>? types;

  AddressComponent({this.longName, this.shortName, this.types});

  @override
  String toString() {
    return 'AddressComponent(longName: $longName, shortName: $shortName, types: $types)';
  }

  factory AddressComponent.fromMap(Map<String, dynamic> data) {
    return AddressComponent(
      longName: data['long_name'] as String?,
      shortName: data['short_name'] as String?,
      types: data['types'] as List<String>?,
    );
  }

  Map<String, dynamic> toMap() => {
        'long_name': longName,
        'short_name': shortName,
        'types': types,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AddressComponent].
  factory AddressComponent.fromJson(String data) {
    return AddressComponent.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AddressComponent] to a JSON string.
  String toJson() => json.encode(toMap());
}
