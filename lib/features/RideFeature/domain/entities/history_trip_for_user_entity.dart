import 'package:fourtyninehub/features/RideFeature/data/models/helpers/category.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/helpers/currency.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/helpers/rider.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/helpers/user.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/helpers/location.dart';

class HistoryTripForUserEntity {
  final String? id;
  final Location? startLocation;
  final Location? targetLocation;
  final User? user;
  final Rider? rider;
  final Category? subCategory;
  final String? fromTitle;
  final String? toTitle;
  final double? profit;
  final bool? autoAccept;
  final bool? isPremium;
  final int? distance;
  final int? duration;
  final int? passengers;
  final double? price;
  final int? calculateB;
  final String? paymentMethod;
  final String? status;
  final int? penalty;
  final bool? payedPenalty;
  final bool? isUserGetCashback;
  final bool? isRiderGetCashback;
  final String? otp;
  final bool? freeTripForDriver;
  final String? holdMoneyForTrip;
  final String? recordingVoice;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? rate;
  final DateTime? expireAt;
  final Currency? currency;

  HistoryTripForUserEntity({
    this.id,
    this.startLocation,
    this.targetLocation,
    this.user,
    this.rider,
    this.subCategory,
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
    this.freeTripForDriver,
    this.holdMoneyForTrip,
    this.recordingVoice,
    this.createdAt,
    this.updatedAt,
    this.rate,
    this.expireAt,
    this.currency,
  });
}