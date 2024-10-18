import 'rider_location.dart';
import 'start_location.dart';
import 'sub_category_id.dart';
import 'target_location.dart';
import 'user_id.dart';
import 'user_location.dart';

class TripResponseModel {
  StartLocation? startLocation;
  TargetLocation? targetLocation;
  bool? isPremium;
  String? id;
  UserId? userId;
  String? riderId;
  SubCategoryId? subCategoryId;
  String? carTypeId;
  String? fromTitle;
  String? toTitle;
  int? profit;
  bool? autoAccept;
  UserLocation? userLocation;
  RiderLocation? riderLocation;
  int? distance;
  double? duration;
  int? passengers;
  int? price;
  int? calculateB;
  String? paymentMethod;
  DateTime? scheduleTime;
  String? status;
  String? note;
  int? penalty;
  bool? payedPenalty;
  bool? isUserGetCashback;
  bool? isRiderGetCashback;
  String? otp;
  DateTime? createdAt;
  DateTime? updatedAt;

  TripResponseModel({
    this.startLocation,
    this.targetLocation,
    this.isPremium,
    this.id,
    this.userId,
    this.riderId,
    this.subCategoryId,
    this.carTypeId,
    this.fromTitle,
    this.toTitle,
    this.profit,
    this.autoAccept,
    this.userLocation,
    this.riderLocation,
    this.distance,
    this.duration,
    this.passengers,
    this.price,
    this.calculateB,
    this.paymentMethod,
    this.scheduleTime,
    this.status,
    this.note,
    this.penalty,
    this.payedPenalty,
    this.isUserGetCashback,
    this.isRiderGetCashback,
    this.otp,
    this.createdAt,
    this.updatedAt,
  });

  factory TripResponseModel.fromJson(Map<String, dynamic> json) {
    return TripResponseModel(
      startLocation: json['startLocation'] == null
          ? null
          : StartLocation.fromJson(
              json['startLocation'] as Map<String, dynamic>),
      targetLocation: json['targetLocation'] == null
          ? null
          : TargetLocation.fromJson(
              json['targetLocation'] as Map<String, dynamic>),
      isPremium: json['isPremium'] as bool?,
      id: json['_id'] as String?,
      userId: json['userId'] == null
          ? null
          : UserId.fromJson(json['userId'] as Map<String, dynamic>),
      riderId: json['riderId'] as String?,
      subCategoryId: json['subCategoryId'] == null
          ? null
          : SubCategoryId.fromJson(
              json['subCategoryId'] as Map<String, dynamic>),
      carTypeId: json['carTypeId'] as String?,
      fromTitle: json['fromTitle'] as String?,
      toTitle: json['toTitle'] as String?,
      profit: json['profit'] as int?,
      autoAccept: json['autoAccept'] as bool?,
      userLocation: json['userLocation'] == null
          ? null
          : UserLocation.fromJson(json['userLocation'] as Map<String, dynamic>),
      riderLocation: json['riderLocation'] == null
          ? null
          : RiderLocation.fromJson(
              json['riderLocation'] as Map<String, dynamic>),
      distance: json['distance'] as int?,
      duration: (json['duration'] as num?)?.toDouble(),
      passengers: json['passengers'] as int?,
      price: json['price'] as int?,
      calculateB: json['calculateB'] as int?,
      paymentMethod: json['paymentMethod'] as String?,
      scheduleTime: json['scheduleTime'] == null
          ? null
          : DateTime.parse(json['scheduleTime'] as String),
      status: json['status'] as String?,
      note: json['note'] as String?,
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
        'isPremium': isPremium,
        '_id': id,
        'userId': userId?.toJson(),
        'riderId': riderId,
        'subCategoryId': subCategoryId?.toJson(),
        'carTypeId': carTypeId,
        'fromTitle': fromTitle,
        'toTitle': toTitle,
        'profit': profit,
        'autoAccept': autoAccept,
        'userLocation': userLocation?.toJson(),
        'riderLocation': riderLocation?.toJson(),
        'distance': distance,
        'duration': duration,
        'passengers': passengers,
        'price': price,
        'calculateB': calculateB,
        'paymentMethod': paymentMethod,
        'scheduleTime': scheduleTime?.toIso8601String(),
        'status': status,
        'note': note,
        'penalty': penalty,
        'payed_penalty': payedPenalty,
        'isUserGetCashback': isUserGetCashback,
        'isRiderGetCashback': isRiderGetCashback,
        'OTP': otp,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
