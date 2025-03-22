class RequestTripUseCaseParams {
  final String subcategoryId;
  final double price;
  final String fromTitle;
  final String toTitle;
  final double distance;
  final int duration;
  final List<double> startLocation;
  final List<double> targetLocation;
  final List<double>? wayPointOne;
  final List<double>? wayPointTwo;
  final int calculateB;
  final String paymentMethod;
  final int passengers;
  final bool comfort;
  final bool nonSmoker;
  final bool autoAccept;
  final bool isPremium;

  RequestTripUseCaseParams({
    required this.subcategoryId,
    required this.price,
    required this.fromTitle,
    required this.toTitle,
    required this.distance,
    required this.duration,
    required this.startLocation,
    required this.targetLocation,
    required this.wayPointOne,
    required this.wayPointTwo,
    required this.calculateB,
    required this.paymentMethod,
    required this.passengers,
    required this.comfort,
    required this.nonSmoker,
    required this.autoAccept,
    required this.isPremium,
  });

  //toJson
  Map<String, dynamic> toJson() => {
    "price": price,
    "fromTitle": fromTitle,
    "toTitle": toTitle,
    "distance": distance,
    "duration": duration,
    "startLocation": startLocation,
    "targetLocation": targetLocation,
    if (wayPointOne != null) "wayPointOne": wayPointOne,
    if (wayPointTwo != null) "wayPointTwo": wayPointTwo,
    "calculate_b": calculateB,
    "paymentMethod" : paymentMethod,
    "passengers" : passengers,
    "comfort" : comfort,
    "nonSmoker" : nonSmoker,
    "autoAccept" : autoAccept,
    "isPremium" : isPremium,
  };

}