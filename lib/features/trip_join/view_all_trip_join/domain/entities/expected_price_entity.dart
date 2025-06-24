// expected_price_trip_entity.dart
class ExpectedPriceTripEntity {
  final double price;
  final double distance;
  final double duration;
  final String destinationAddress;
  final String originAddress;
  final  List<List<double>> polyline; // Can be List<Map> or String
  final String type;

  ExpectedPriceTripEntity({
    required this.price,
    required this.distance,
    required this.duration,
    required this.destinationAddress,
    required this.originAddress,
    required this.polyline,
    required this.type,
  });
}