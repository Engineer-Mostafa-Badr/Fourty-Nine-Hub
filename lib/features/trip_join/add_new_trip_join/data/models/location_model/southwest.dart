import 'dart:convert';

class Southwest {
  double? lat;
  double? lng;

  Southwest({this.lat, this.lng});

  @override
  String toString() => 'Southwest(lat: $lat, lng: $lng)';

  factory Southwest.fromMap(Map<String, dynamic> data) => Southwest(
        lat: (data['lat'] as num?)?.toDouble(),
        lng: (data['lng'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'lat': lat,
        'lng': lng,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Southwest].
  factory Southwest.fromJson(String data) {
    return Southwest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Southwest] to a JSON string.
  String toJson() => json.encode(toMap());
}
