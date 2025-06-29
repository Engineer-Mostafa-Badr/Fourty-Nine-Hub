class ExpectedPriceTripEntity {
  final double pricePerSeat;
  final double distance;
  final double duration;
  final String destinationAddress;
  final String originAddress;
  final List<List<double>> polyline;
  final String type;

  ExpectedPriceTripEntity({
    required this.pricePerSeat,
    required this.distance,
    required this.duration,
    required this.destinationAddress,
    required this.originAddress,
    required this.polyline,
    required this.type,
  });
}
