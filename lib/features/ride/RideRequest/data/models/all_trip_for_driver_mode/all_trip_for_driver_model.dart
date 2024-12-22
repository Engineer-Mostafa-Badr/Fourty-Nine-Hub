import 'start_location.dart';
import 'sub_category_id.dart';
import 'target_location.dart';
import 'user_id.dart';

class AllTripForDriverModel {
  StartLocation? startLocation;
  TargetLocation? targetLocation;
  String? id;
  UserId? userId;
  dynamic riderId;
  SubCategoryId? subCategoryId;
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

  AllTripForDriverModel({
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

  factory AllTripForDriverModel.fromJson(Map<String, dynamic> json) {
    return AllTripForDriverModel(
      startLocation: json['startLocation'] == null
          ? null
          : StartLocation.fromJson(
              json['startLocation'] as Map<String, dynamic>),
      targetLocation: json['targetLocation'] == null
          ? null
          : TargetLocation.fromJson(
              json['targetLocation'] as Map<String, dynamic>),
      id: json['_id'] as String?,
      userId: json['userId'] == null
          ? null
          : UserId.fromJson(json['userId'] as Map<String, dynamic>),
      riderId: json['riderId'] as dynamic,
      subCategoryId: json['subCategoryId'] == null
          ? null
          : SubCategoryId.fromJson(
              json['subCategoryId'] as Map<String, dynamic>),
      carTypeId: json['carTypeId'] as dynamic,
      fromTitle: json['fromTitle'] as String?,
      toTitle: json['toTitle'] as String?,
      profit: json['profit'] as int?,
      autoAccept: json['autoAccept'] as bool?,
      isPremium: json['isPremium'] as bool?,
      distance: json['distance'] as int?,
      duration: json['duration'] as int?,
      passengers: json['passengers'] as int?,
      price: double.parse(json['price'].toString()),
      calculateB: json['calculateB'] as int?,
      paymentMethod: json['paymentMethod'] as String?,
      status: json['status'] as String?,
      penalty: json['penalty'] as int?,
      payedPenalty: json['payed_penalty'] as bool?,
      isUserGetCashback: json['isUserGetCashback'] as bool?,
      isRiderGetCashback: json['isRiderGetCashback'] as bool?,
      otp: json['OTP'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'startLocation': startLocation?.toJson(),
        'targetLocation': targetLocation?.toJson(),
        '_id': id,
        'userId': userId?.toJson(),
        'riderId': riderId,
        'subCategoryId': subCategoryId?.toJson(),
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
