import 'dart:developer';

import 'start_location.dart';
import 'target_location.dart';

class CheckAcceptTripFromDriverModel {
  StartLocation? startLocation;
  TargetLocation? targetLocation;
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

  CheckAcceptTripFromDriverModel({
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

  factory CheckAcceptTripFromDriverModel.fromJson(Map<String, dynamic> json) {
    log(json.toString(), name: "slkdjflsdkjflskdjfdkdkdd");
    return CheckAcceptTripFromDriverModel(
      startLocation: json['startLocation'] == null
          ? null
          : StartLocation.fromJson(
              json['startLocation'] as Map<String, dynamic>),
      targetLocation: json['targetLocation'] == null
          ? null
          : TargetLocation.fromJson(
              json['targetLocation'] as Map<String, dynamic>),
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      riderId: json['riderId'] as dynamic,
      subCategoryId: json['subCategoryId'] as String?,
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
      otp: (json['OTP'] ?? "").toString(),
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
