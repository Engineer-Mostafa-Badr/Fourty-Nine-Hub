class StartLocation {
  String? type;
  List<dynamic>? coordinates;

  StartLocation({this.type, this.coordinates});

  factory StartLocation.fromJson(Map<String, dynamic> json) => StartLocation(
        type: json['type'] as String?,
        coordinates: json['coordinates'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}
