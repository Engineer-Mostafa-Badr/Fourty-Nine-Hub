class GetTripInfoModel {
  double? price;
  dynamic lowestFare;
  String? from;
  String? to;
  List<dynamic>? startLocation;
  List<dynamic>? targetLocation;
  int? distance;
  int? duration;
  int? calculateB;
  String? polyline;
  String? type;

  GetTripInfoModel({
    this.price,
    this.lowestFare,
    this.from,
    this.to,
    this.startLocation,
    this.targetLocation,
    this.distance,
    this.duration,
    this.calculateB,
    this.polyline,
    this.type,
  });

  factory GetTripInfoModel.fromJson(Map<String, dynamic> json) {
    return GetTripInfoModel(
      price: (json['price'] as num?)?.toDouble(),
      lowestFare: json['lowestFare'] as dynamic,
      from: json['from'] as String?,
      to: json['to'] as String?,
      startLocation: json['startLocation'] as List<dynamic>?,
      targetLocation: json['targetLocation'] as List<dynamic>?,
      distance: json['distance'] as int?,
      duration: json['duration'] as int?,
      calculateB: json['calculate_b'] as int?,
      polyline: json['polyline'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'price': price,
        'lowestFare': lowestFare,
        'from': from,
        'to': to,
        'startLocation': startLocation,
        'targetLocation': targetLocation,
        'distance': distance,
        'duration': duration,
        'calculate_b': calculateB,
        'polyline': polyline,
        'type': type,
      };
}
