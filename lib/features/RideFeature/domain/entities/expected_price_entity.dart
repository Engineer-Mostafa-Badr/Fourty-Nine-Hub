import 'package:fourtyninehub/features/RideFeature/data/models/expected_price_model.dart';

class RideExpectedPriceEntity{
  double priceForCaptain;
  double priceForWomen;
  double priceForTaxi;
  double priceForScooter;
  double priceForSUV;
   double priceForPremium;
   double priceForIntercity;
  final double lowestFare;
  final double highestFare;
  final String from;
  final String to;
  final List<double> startLocation;
  final List<double> targetLocation;
  final double distance;
  final double duration;
  List<List<double>> polyline;
  final double comfort;
  final double nonSmoking;
  final double autoAccept;
  final String type;
  final List<SubcategoryModel> subcategoryModel;

  RideExpectedPriceEntity({required this.priceForWomen, required this.priceForTaxi, required this.priceForScooter, required this.priceForCaptain, required this.priceForPremium, required this.priceForIntercity, required this.priceForSUV, required this.lowestFare, required this.highestFare, required this.from, required this.to, required this.startLocation, required this.targetLocation, required this.distance, required this.duration, required this.polyline, required this.comfort, required this.type, required this.nonSmoking, required this.autoAccept, required this.subcategoryModel});


}