class Location {
  dynamic lat;
  double? lng;

  Location({this.lat, this.lng});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json['lat'] as dynamic,
        lng: double.parse(json['lng'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}
