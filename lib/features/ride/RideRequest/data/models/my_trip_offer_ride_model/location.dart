class Location {
  String? type;
  List<dynamic>? coordinates;

  Location({this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json['type'] as String?,
        coordinates: json['coordinates'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}
