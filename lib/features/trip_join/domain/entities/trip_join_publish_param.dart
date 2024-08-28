class TripJoinPublishParam {
  String? vehicleModel;
  String? vehicleBrand;
  String? categoryId;
  String? from;
  String? to;
  num? distance;
  num? duration;
  num? passengers;
  num? price;
  String? phone;
  num? time;
  bool? isRepeat;

  TripJoinPublishParam({
    this.vehicleModel,
    this.vehicleBrand,
    this.categoryId,
    this.from,
    this.to,
    this.distance,
    this.duration,
    this.passengers,
    this.price,
    this.phone,
    this.time,
    this.isRepeat,
  });

  @override
  String toString() {
    return 'TripJoinPublishParams(vehicleModel: $vehicleModel, vehicleBrand: $vehicleBrand, categoryId: $categoryId, from: $from, to: $to, distance: $distance, duration: $duration, passengers: $passengers, price: $price, phone: $phone, time: $time, isRepeat: $isRepeat)';
  }

  factory TripJoinPublishParam.fromJson(Map<String, dynamic> json) {
    return TripJoinPublishParam(
      vehicleModel: json['vehicleModel'] as String?,
      vehicleBrand: json['vehicleBrand'] as String?,
      categoryId: json['categoryId'] as String?,
      from: json['from'] as String?,
      to: json['to'] as String?,
      distance: json['distance'] as num?,
      duration: json['duration'] as num?,
      passengers: json['passengers'] as num?,
      price: json['price'] as num?,
      phone: json['phone'] as String?,
      time: json['time'] as num?,
      isRepeat: json['isRepeat'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'vehicleModel': vehicleModel,
        'vehicleBrand': vehicleBrand,
        'categoryId': categoryId,
        'from': from,
        'to': to,
        'distance': distance,
        'duration': duration,
        'passengers': passengers,
        'price': price,
        'phone': phone,
        'time': time,
        'isRepeat': isRepeat,
      };

  TripJoinPublishParam copyWith({
    String? vehicleModel,
    String? vehicleBrand,
    String? categoryId,
    String? from,
    String? to,
    num? distance,
    num? duration,
    String? priceId,
    num? passengers,
    num? price,
    String? phone,
    num? time,
    bool? isRepeat,
  }) {
    return TripJoinPublishParam(
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      categoryId: categoryId ?? this.categoryId,
      from: from ?? this.from,
      to: to ?? this.to,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      passengers: passengers ?? this.passengers,
      price: price ?? this.price,
      phone: phone ?? this.phone,
      time: time ?? this.time,
      isRepeat: isRepeat ?? this.isRepeat,
    );
  }
}
