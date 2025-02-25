class RequestTripEntity {
  final String id;
  final double price;
  final String fromTitle;
  final String toTitle;
  final double distance;
  final int duration;
  final List<double> startLocation;
  final List<double> targetLocation;
  final int calculateB;
  final String paymentMethod;
  final int passengers;
  final bool comfort;
  final bool autoAccept;

  RequestTripEntity({
    required this.id,
    required this.price,
    required this.fromTitle,
    required this.toTitle,
    required this.distance,
    required this.duration,
    required this.startLocation,
    required this.targetLocation,
    required this.calculateB,
    required this.paymentMethod,
    required this.passengers,
    required this.comfort,
    required this.autoAccept,
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
    "calculate_b": calculateB,
    "paymentMethod" : paymentMethod,
    "passengers" : passengers,
    "comfort" : comfort,
    "autoAccept" : autoAccept
  };

}