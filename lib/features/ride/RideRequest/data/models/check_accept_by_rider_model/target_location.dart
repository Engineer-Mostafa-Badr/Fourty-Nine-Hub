class TargetLocation {
  List<dynamic>? coordinates;

  TargetLocation({this.coordinates});

  factory TargetLocation.fromJson(Map<String, dynamic> json) {
    return TargetLocation(
      coordinates: json['coordinates'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'coordinates': coordinates,
      };
}
