class TargetLocation {
  String? type;
  List<dynamic>? coordinates;

  TargetLocation({this.type, this.coordinates});

  factory TargetLocation.fromJson(Map<String, dynamic> json) {
    return TargetLocation(
      type: json['type'] as String?,
      coordinates: json['coordinates'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}
