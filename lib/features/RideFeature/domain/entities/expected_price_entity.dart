class RideExpectedPriceEntity{
  final int priceForWomen;
  final int priceForTaxi;
  final int priceForScooter;
  final int captainPrice;
  final int priceForPremium;
  final int priceForSUV;
  final int nonSmoker;
  final int lowestFare;
  final int highestFare;
  final String from;
  final String to;
  final List<double> startLocation;
  final List<double> targetLocation;
  final int distance;
  final double duration;
  final int calculateB;
  final List<List<double>> polyline;
  final int comfort;
  final String type;

  RideExpectedPriceEntity({required this.priceForWomen, required this.priceForTaxi, required this.priceForScooter, required this.captainPrice, required this.priceForPremium, required this.priceForSUV, required this.nonSmoker, required this.lowestFare, required this.highestFare, required this.from, required this.to, required this.startLocation, required this.targetLocation, required this.distance, required this.duration, required this.calculateB, required this.polyline, required this.comfort, required this.type});


}