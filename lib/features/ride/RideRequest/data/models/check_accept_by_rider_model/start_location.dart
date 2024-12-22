class StartLocation {
  List<dynamic>? coordinates;

  StartLocation({this.coordinates});

  factory StartLocation.fromJson(Map<String, dynamic> json) => StartLocation(
        coordinates: json['coordinates'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'coordinates': coordinates,
      };
}
