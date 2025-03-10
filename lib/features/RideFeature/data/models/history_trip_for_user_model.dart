import 'package:fourtyninehub/features/RideFeature/data/models/helpers/category.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/helpers/currency.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/helpers/rider.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/helpers/user.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/helpers/location.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/history_trip_for_user_entity.dart';

class HistoryTripForUserModel extends HistoryTripForUserEntity{

  HistoryTripForUserModel({
    required super.id,
    required super.startLocation,
    required super.targetLocation,
    required super.user,
    required super.rider,
    required super.subCategory,
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
    required super.currency,
});

  factory HistoryTripForUserModel.fromJson(Map<String, dynamic> json) {
    return HistoryTripForUserModel(
      id: json['_id'],
      startLocation: json['startLocation'] != null ? Location.fromJson(json['startLocation']) : null,
      targetLocation: json['targetLocation'] != null ? Location.fromJson(json['targetLocation']) : null,
      user: json['userId'] != null ? User.fromJson(json['userId']) : null,
      rider: json['riderId'] != null ? Rider.fromJson(json['riderId']) : null,
      subCategory: json['subCategoryId'] != null ? Category.fromJson(json['subCategoryId']) : null,
      fromTitle: json['fromTitle'],
      toTitle: json['toTitle'],
      profit: json['profit']?.toDouble(),
      autoAccept: json['autoAccept'],
      isPremium: json['isPremium'],
      distance: json['distance'],
      duration: json['duration'],
      passengers: json['passengers'],
      price: json['price']?.toDouble(),
      calculateB: json['calculateB'],
      paymentMethod: json['paymentMethod'],
      status: json['status'],
      penalty: json['penalty'],
      payedPenalty: json['payed_penalty'],
      isUserGetCashback: json['isUserGetCashback'],
      isRiderGetCashback: json['isRiderGetCashback'],
      otp: json['OTP'],
      freeTripForDriver: json['freeTripForDriver'],
      holdMoneyForTrip: json['holdMoneyForTrip'],
      recordingVoice: json['recordingVoice'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      rate: json['rate'],
      expireAt: json['expireAt'] != null ? DateTime.parse(json['expireAt']) : null,
      currency: json['currencyEn'] != null || json['currencyAr'] != null ? Currency(currencyEn: json['currencyEn'], currencyAr: json['currencyAr']) : null,
    );
  }
}