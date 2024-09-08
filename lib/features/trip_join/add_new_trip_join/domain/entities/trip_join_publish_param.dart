class TripJoinPublishParam {
  String? vehicleModel;
  String? vehicleBrand;
  String? categoryId;
  // arabic address fetched from the backend
  String? fromAr;
  String? toAr;
  // english address fetched from geocoding api
  String? fromEn;
  String? toEn;
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
    this.fromAr,
    this.toAr,
    this.fromEn,
    this.toEn,
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
    return 'TripJoinPublishParams(vehicleModel: $vehicleModel, vehicleBrand: $vehicleBrand, categoryId: $categoryId, fromAr: $fromAr, toAr: $toAr, fromEn: $fromEn, toEn: $toEn, distance: $distance, duration: $duration, passengers: $passengers, price: $price, phone: $phone, time: $time, isRepeat: $isRepeat)';
  }

  factory TripJoinPublishParam.fromJson(Map<String, dynamic> json) {
    return TripJoinPublishParam(
      vehicleModel: json['vehicleModel'] as String?,
      vehicleBrand: json['vehicleBrand'] as String?,
      categoryId: json['categoryId'] as String?,
      fromAr: json['fromAr'] as String?,
      toAr: json['toAr'] as String?,
      fromEn: json['fromEn'] as String?,
      toEn: json['toEn'] as String?,
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
        'fromAr': fromAr,
        'toAr': toAr,
        'fromEn': fromEn,
        'toEn': toEn,
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
    String? fromAr,
    String? toAr,
    String? fromEn,
    String? toEn,
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
      fromAr: fromAr ?? fromAr,
      toAr: toAr ?? toAr,
      fromEn: fromEn ?? fromEn,
      toEn: toEn ?? toEn,
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
