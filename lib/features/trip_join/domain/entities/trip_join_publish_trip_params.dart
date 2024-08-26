class TripJoinPublishTripParams {
  String? vehicleModel;
  String? vehicleBrand;
  String? vehicleColor;
  String? vehicleType;
  String? vehicleYear;
  String? categoryId;
  List<String>? startLocation;
  List<String>? targetLocation;
  num? passengers;
  num? price;
  num? phone;
  num? time;
  bool? isRepeat;
  String? note;

  TripJoinPublishTripParams({
    this.vehicleModel,
    this.vehicleBrand,
    this.vehicleColor,
    this.vehicleType,
    this.vehicleYear,
    this.categoryId,
    this.startLocation,
    this.targetLocation,
    this.passengers,
    this.price,
    this.phone,
    this.time,
    this.isRepeat,
    this.note,
  });

  @override
  String toString() {
    return 'TripJoinPublishTripParams(vehicleModel: $vehicleModel, vehicleBrand: $vehicleBrand, vehicleColor: $vehicleColor, vehicleType: $vehicleType, vehicleYear: $vehicleYear, categoryId: $categoryId, startLocation: $startLocation, targetLocation: $targetLocation, passengers: $passengers, price: $price, phone: $phone, time: $time, isRepeat: $isRepeat, note: $note)';
  }

  factory TripJoinPublishTripParams.fromJson(Map<String, dynamic> json) {
    return TripJoinPublishTripParams(
      vehicleModel: json['vehicleModel'] as String?,
      vehicleBrand: json['vehicleBrand'] as String?,
      vehicleColor: json['vehicleColor'] as String?,
      vehicleType: json['vehicleType'] as String?,
      vehicleYear: json['vehicleYear'] as String?,
      categoryId: json['categoryId'] as String?,
      startLocation: json['startLocation'] as List<String>?,
      targetLocation: json['targetLocation'] as List<String>?,
      passengers: json['passengers'] as num?,
      price: json['price'] as num?,
      phone: json['phone'] as num?,
      time: json['time'] as num?,
      isRepeat: json['isRepeat'] as bool?,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'vehicleModel': vehicleModel,
        'vehicleBrand': vehicleBrand,
        'vehicleColor': vehicleColor,
        'vehicleType': vehicleType,
        'vehicleYear': vehicleYear,
        'categoryId': categoryId,
        'startLocation': startLocation,
        'targetLocation': targetLocation,
        'passengers': passengers,
        'price': price,
        'phone': phone,
        'time': time,
        'isRepeat': isRepeat,
        'note': note,
      };

  TripJoinPublishTripParams copyWith({
    String? vehicleModel,
    String? vehicleBrand,
    String? vehicleColor,
    String? vehicleType,
    String? vehicleYear,
    String? categoryId,
    List<String>? startLocation,
    List<String>? targetLocation,
    num? passengers,
    num? price,
    num? phone,
    num? time,
    bool? isRepeat,
    String? note,
  }) {
    return TripJoinPublishTripParams(
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleYear: vehicleYear ?? this.vehicleYear,
      categoryId: categoryId ?? this.categoryId,
      startLocation: startLocation ?? this.startLocation,
      targetLocation: targetLocation ?? this.targetLocation,
      passengers: passengers ?? this.passengers,
      price: price ?? this.price,
      phone: phone ?? this.phone,
      time: time ?? this.time,
      isRepeat: isRepeat ?? this.isRepeat,
      note: note ?? this.note,
    );
  }
}
