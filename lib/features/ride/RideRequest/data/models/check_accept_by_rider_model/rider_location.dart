class RiderLocation {
  List<dynamic>? coordinates;

  RiderLocation({this.coordinates});

  factory RiderLocation.fromJson(Map<String, dynamic> json) => RiderLocation(
        coordinates: json['coordinates'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'coordinates': coordinates,
      };
}
