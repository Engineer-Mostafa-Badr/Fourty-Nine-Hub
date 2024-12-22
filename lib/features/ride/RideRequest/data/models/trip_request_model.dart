class TripRequestModel {
  double? price;
  String? fromTitle;
  String? toTitle;
  int? distance;
  int? duration;
  List<dynamic>? startLocation;
  List<dynamic>? targetLocation;
  int? calculateB;
  String? paymentMethod;
  int? passengers;
  bool? comfort;
  bool? autoAccept;
  bool? isPremium;

  TripRequestModel({
    this.price,
    this.fromTitle,
    this.toTitle,
    this.distance,
    this.duration,
    this.startLocation,
    this.targetLocation,
    this.calculateB,
    this.paymentMethod,
    this.passengers,
    this.comfort,
    this.autoAccept,
    this.isPremium,
  });

  factory TripRequestModel.fromJson(Map<String, dynamic> json) {
    return TripRequestModel(
      price: double.parse(json['price'].toString()),
      fromTitle: json['fromTitle'] as String?,
      toTitle: json['toTitle'] as String?,
      distance: json['distance'] as int?,
      duration: json['duration'] as int?,
      startLocation: json['startLocation'] as List<double>?,
      targetLocation: json['targetLocation'] as List<double>?,
      calculateB: json['calculate_b'] as int?,
      paymentMethod: json['paymentMethod'] as String?,
      passengers: json['passengers'] as int?,
      comfort: json['comfort'] as bool?,
      autoAccept: json['autoAccept'] as bool?,
      isPremium: json['isPremium'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'price': price,
        'fromTitle': fromTitle,
        'toTitle': toTitle,
        'distance': distance,
        'duration': duration,
        'startLocation': startLocation,
        'targetLocation': targetLocation,
        'calculate_b': calculateB,
        'paymentMethod': paymentMethod,
        'passengers': passengers,
        'comfort': comfort,
        'autoAccept': autoAccept,
        'isPremium': isPremium,
      };
}
