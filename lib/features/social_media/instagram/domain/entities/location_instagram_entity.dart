class LocationInstagramEntity {
  final String formattedAddress;
  final String name;
  final double lat;
  final double lng;

  LocationInstagramEntity({
    required this.formattedAddress,
    required this.name,
    required this.lat,
    required this.lng,
  });

  //toJson
  Map<String, dynamic> toMap() => {
        'formattedAddress': formattedAddress,
        'name': name,
        'lat': lat,
        'lng': lng,
      };
}
