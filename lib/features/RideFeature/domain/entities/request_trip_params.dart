class RequestTripUseCaseParams {
  final String subcategoryId;
  final double price;
  final String fromTitle;
  final String toTitle;
  final String? wayPointOneTitle;
  final String? wayPointTwoTitle;
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
  final List<List<double>> polyline;
  final String phoneNumber;

  RequestTripUseCaseParams({
    required this.subcategoryId,
    required this.price,
    required this.fromTitle,
    required this.toTitle,
    required this.wayPointOneTitle,
    required this.wayPointTwoTitle,
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
    required this.polyline,
    required this.phoneNumber,
  });

  //toJson
  Map<String, dynamic> toJson() => {
    "price": price,
    "fromTitle": fromTitle,
    "toTitle": toTitle,
    "distance": distance.toInt(),
    "duration": duration,
    "startLocation": [startLocation[1],startLocation[0]],
    "targetLocation": [targetLocation[1],targetLocation[0]],
    if (wayPointOne != null) "wayPointOne": wayPointOne,
    if (wayPointTwo != null) "wayPointTwo": wayPointTwo,
    if (wayPointOneTitle != null) "wayPointOneTitle": wayPointOneTitle,
    if (wayPointTwoTitle != null) "wayPointTwoTitle": wayPointTwoTitle,
    "calculate_b": calculateB,
    "paymentMethod" : paymentMethod,
    "passengers" : passengers,
    "comfort" : comfort,
    "nonSmoker" : nonSmoker,
    "autoAccept" : autoAccept,
    "isPremium" : isPremium,
    "polyline" : polyline,
    "riderPhone": phoneNumber,
    "clientCurrentLocation": {
      "latitude": startLocation[1],
      "longitude": startLocation[0],
    }
  };

}