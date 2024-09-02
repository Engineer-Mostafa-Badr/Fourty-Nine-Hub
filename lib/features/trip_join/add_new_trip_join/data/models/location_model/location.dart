import 'dart:convert';

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  @override
  String toString() => 'Location(lat: $lat, lng: $lng)';

  factory Location.fromMap(Map<String, dynamic> data) => Location(
        lat: (data['lat'] as num?)?.toDouble(),
        lng: (data['lng'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'lat': lat,
        'lng': lng,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Location].
  factory Location.fromJson(String data) {
    return Location.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Location] to a JSON string.
  String toJson() => json.encode(toMap());
}
