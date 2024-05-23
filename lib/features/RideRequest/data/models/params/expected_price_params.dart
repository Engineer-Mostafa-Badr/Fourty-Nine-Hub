class ExpectedPriceParams {
  final double fromLat;
  final double fromLng;
  final double toLat;
  final double toLng;
  ExpectedPriceParams({
    required this.fromLat,
    required this.fromLng,
    required this.toLat,
    required this.toLng,
  });

  Map<String, dynamic> toJson() => {
        "user_longitude": fromLng,
        "user_latitude": fromLat,
        "location_latitude": toLat,
        "location_longitude": toLng,
      };
}
