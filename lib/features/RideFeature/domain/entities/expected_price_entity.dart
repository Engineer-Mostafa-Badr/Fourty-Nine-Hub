class RideExpectedPriceEntity{
  double priceForCaptain;
  double priceForWomen;
  double priceForTaxi;
  double priceForScooter;
  double priceForSUV;
  final double priceForPremium;
  final double lowestFare;
  final double highestFare;
  final String from;
  final String to;
  final List<double> startLocation;
  final List<double> targetLocation;
  final double distance;
  final double duration;
  final List<List<double>> polyline;
  final double comfort;
  final double nonSmoking;
  final double autoAccept;
  final String type;

  RideExpectedPriceEntity({required this.priceForWomen, required this.priceForTaxi, required this.priceForScooter, required this.priceForCaptain, required this.priceForPremium, required this.priceForSUV, required this.lowestFare, required this.highestFare, required this.from, required this.to, required this.startLocation, required this.targetLocation, required this.distance, required this.duration, required this.polyline, required this.comfort, required this.type, required this.nonSmoking, required this.autoAccept});


}