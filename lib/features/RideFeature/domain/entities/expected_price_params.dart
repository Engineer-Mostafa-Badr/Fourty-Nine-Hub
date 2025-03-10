class RideExpectedPriceParams {
  final String id;
  final List<double> startLocation;
  final List<double> targetLocation;
  final bool comfort;

  RideExpectedPriceParams({required this.id,required this.startLocation, required this.targetLocation, required this.comfort});

  //toJson
  Map<String, dynamic> toJson() => {
    "startLocation": startLocation,
    "targetLocation": targetLocation,
    "comfort": comfort,
  };
}