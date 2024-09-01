import 'dart:convert';

class Northeast {
  double? lat;
  double? lng;

  Northeast({this.lat, this.lng});

  @override
  String toString() => 'Northeast(lat: $lat, lng: $lng)';

  factory Northeast.fromMap(Map<String, dynamic> data) => Northeast(
        lat: (data['lat'] as num?)?.toDouble(),
        lng: (data['lng'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'lat': lat,
        'lng': lng,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Northeast].
  factory Northeast.fromJson(String data) {
    return Northeast.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Northeast] to a JSON string.
  String toJson() => json.encode(toMap());
}
