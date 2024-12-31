class Location {
  String type;
  List<double>? coordinates;

  Location({required this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] as String,
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}

class CheckAcceptByRiderModel {
  Location? startLocation;
  Location? targetLocation;
  String? id;
  String? userId;
  dynamic riderId;
  String? subCategoryId;
  dynamic carTypeId;
  String? fromTitle;
  String? toTitle;
  int? profit;
  bool? autoAccept;
  bool? isPremium;
  int? distance;
  int? duration;
  int? passengers;
  double? price;
  int? calculateB;
  String? paymentMethod;
  String? status;
  int? penalty;
  bool? payedPenalty;
  bool? isUserGetCashback;
  bool? isRiderGetCashback;
  String? otp;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? driverPhone;
  String? userPhone;
  CheckAcceptByRiderModel({
    this.startLocation,
    this.targetLocation,
    this.id,
    this.userId,
    this.riderId,
    this.subCategoryId,
    this.carTypeId,
    this.fromTitle,
    this.toTitle,
    this.profit,
    this.autoAccept,
    this.isPremium,
    this.distance,
    this.driverPhone,
    this.userPhone,
    this.duration,
    this.passengers,
    this.price,
    this.calculateB,
    this.paymentMethod,
    this.status,
    this.penalty,
    this.payedPenalty,
    this.isUserGetCashback,
    this.isRiderGetCashback,
    this.otp,
    this.createdAt,
    this.updatedAt,
  });

  factory CheckAcceptByRiderModel.fromJson(Map<String, dynamic> json) {
    return CheckAcceptByRiderModel(
      startLocation: json['isTripExists']['startLocation'] == null
          ? null
          : Location.fromJson(json['isTripExists']['startLocation']),
      targetLocation: json['isTripExists']['targetLocation'] == null
          ? null
          : Location.fromJson(json['isTripExists']['targetLocation']),
      id: json['isTripExists']['_id'] as String?,
      userId: json['isTripExists']['userId'] as String?,
      riderId: json['isTripExists']['riderId'],
      userPhone: json['userPhone'] as String?,
      driverPhone: json['driverPhone'] as String?,
      subCategoryId: json['isTripExists']['subCategoryId'] as String?,
      carTypeId: json['isTripExists']['carTypeId'],
      fromTitle: json['isTripExists']['fromTitle'] as String?,
      toTitle: json['isTripExists']['toTitle'] as String?,
      profit: json['isTripExists']['profit'] as int?,
      autoAccept: json['isTripExists']['autoAccept'] as bool?,
      isPremium: json['isTripExists']['isPremium'] as bool?,
      distance: json['isTripExists']['distance'] as int?,
      duration: json['isTripExists']['duration'] as int?,
      passengers: json['isTripExists']['passengers'] as int?,
      price: double.tryParse(json['isTripExists']['price'].toString()),
      calculateB: json['isTripExists']['calculateB'] as int?,
      paymentMethod: json['isTripExists']['paymentMethod'] as String?,
      status: (json['isTripExists']['status'].toString()) as String?,
      penalty: json['isTripExists']['penalty'] as int?,
      payedPenalty: json['isTripExists']['payed_penalty'] as bool?,
      isUserGetCashback: json['isTripExists']['isUserGetCashback'] as bool?,
      isRiderGetCashback: json['isTripExists']['isRiderGetCashback'] as bool?,
      otp: json['isTripExists']['OTP'] as String?,
      createdAt: json['isTripExists']['createdAt'] == null
          ? null
          : DateTime.parse(json['isTripExists']['createdAt'] as String),
      updatedAt: json['isTripExists']['updatedAt'] == null
          ? null
          : DateTime.parse(json['isTripExists']['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'startLocation': startLocation?.toJson(),
        'targetLocation': targetLocation?.toJson(),
        '_id': id,
        'userId': userId,
        'riderId': riderId,
        'subCategoryId': subCategoryId,
        'carTypeId': carTypeId,
        'fromTitle': fromTitle,
        'toTitle': toTitle,
        'profit': profit,
        'autoAccept': autoAccept,
        'isPremium': isPremium,
        'distance': distance,
        'duration': duration,
        'passengers': passengers,
        'price': price,
        'calculateB': calculateB,
        'paymentMethod': paymentMethod,
        'status': status,
        'penalty': penalty,
        'payed_penalty': payedPenalty,
        'isUserGetCashback': isUserGetCashback,
        'isRiderGetCashback': isRiderGetCashback,
        'OTP': otp,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
