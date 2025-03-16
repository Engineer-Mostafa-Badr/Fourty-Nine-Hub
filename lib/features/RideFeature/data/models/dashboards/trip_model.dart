import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/rider_dashboard_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trip_entity.dart';

import 'car_type_model.dart';
import 'location_model.dart';
import 'sub_category_model.dart';
import 'user_profile_model.dart';

class TripModel extends TripEntity {
  TripModel({
    required LocationModel super.startLocation,
    required LocationModel super.targetLocation,
    required super.tripRatingId,
    required super.id,
    required UserModel super.userId,
    required RiderDashboardModel? super.riderId,
    required SubCategoryModel super.subCategoryId,
    required CarTypeModel? super.carTypeId,
    required super.fromTitle,
    required super.toTitle,
    required super.profit,
    required super.autoAccept,
    required super.isPremium,
    required super.distance,
    required super.duration,
    required super.passengers,
    required super.price,
    required super.calculateB,
    required super.paymentMethod,
    required super.status,
    required super.penalty,
    required super.payedPenalty,
    required super.isUserGetCashback,
    required super.isRiderGetCashback,
    required super.otp,
    required super.freeTripForDriver,
    required super.holdMoneyForTrip,
    required super.recordingVoice,
    required super.createdAt,
    required super.updatedAt,
    required super.rate,
    required super.expireAt,
    required super.startTime,
    required super.currencyEn,
    required super.currencyAr,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      startLocation: LocationModel.fromJson(json['startLocation']),
      targetLocation: LocationModel.fromJson(json['targetLocation']),
      tripRatingId: json['tripRatingId'],
      id: json['_id'],
      userId: UserModel.fromJson(json['userId']),
      riderId: json['riderId'] != null ? RiderDashboardModel.fromJson(json['riderId']) : null,
      subCategoryId: SubCategoryModel.fromJson(json['subCategoryId']),
      carTypeId: json['carTypeId'] != null ? CarTypeModel.fromJson(json['carTypeId']) : null,
      fromTitle: json['fromTitle'],
      toTitle: json['toTitle'],
      profit: json['profit'].toDouble(),
      autoAccept: json['autoAccept'],
      isPremium: json['isPremium'],
      distance: json['distance'],
      duration: json['duration'],
      passengers: json['passengers'],
      price: json['price'].toDouble(),
      calculateB: json['calculateB'].toDouble(),
      paymentMethod: json['paymentMethod'],
      status: json['status'],
      penalty: json['penalty'].toDouble(),
      payedPenalty: json['payed_penalty'],
      isUserGetCashback: json['isUserGetCashback'],
      isRiderGetCashback: json['isRiderGetCashback'],
      otp: json['OTP'],
      freeTripForDriver: json['freeTripForDriver'],
      holdMoneyForTrip: json['holdMoneyForTrip'],
      recordingVoice: json['recordingVoice'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      rate: json['rate'],
      expireAt: DateTime.parse(json['expireAt']),
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      currencyEn: json['currencyEn'],
      currencyAr: json['currencyAr'],
    );
  }
}