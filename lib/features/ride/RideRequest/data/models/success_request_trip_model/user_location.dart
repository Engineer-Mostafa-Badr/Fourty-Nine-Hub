class UserLocation {
  List<dynamic>? coordinates;

  UserLocation({this.coordinates});

  factory UserLocation.fromJson(Map<String, dynamic> json) => UserLocation(
        coordinates: json['coordinates'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'coordinates': coordinates,
      };
}
