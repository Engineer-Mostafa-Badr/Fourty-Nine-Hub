import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/car_type_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/location_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/rider_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/sub_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/user_entity.dart';

class TripEntity extends Equatable {
  final LocationEntity startLocation;
  final LocationEntity targetLocation;
  final String? tripRatingId;
  final String id;
  final UserEntity userId;
  final RiderEntity? riderId;
  final SubCategoryEntity subCategoryId;
  final CarTypeEntity? carTypeId;
  final String fromTitle;
  final String toTitle;
  final double profit;
  final bool autoAccept;
  final bool isPremium;
  final int distance;
  final int duration;
  final int passengers;
  final double price;
  final double calculateB;
  final String paymentMethod;
  final String status;
  final double penalty;
  final bool payedPenalty;
  final bool isUserGetCashback;
  final bool isRiderGetCashback;
  final String otp;
  final bool freeTripForDriver;
  final String? holdMoneyForTrip;
  final String? recordingVoice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? rate;
  final DateTime expireAt;
  final DateTime? startTime;
  final String currencyEn;
  final String currencyAr;

  TripEntity({
    required this.startLocation,
    required this.targetLocation,
    required this.tripRatingId,
    required this.id,
    required this.userId,
    required this.riderId,
    required this.subCategoryId,
    required this.carTypeId,
    required this.fromTitle,
    required this.toTitle,
    required this.profit,
    required this.autoAccept,
    required this.isPremium,
    required this.distance,
    required this.duration,
    required this.passengers,
    required this.price,
    required this.calculateB,
    required this.paymentMethod,
    required this.status,
    required this.penalty,
    required this.payedPenalty,
    required this.isUserGetCashback,
    required this.isRiderGetCashback,
    required this.otp,
    required this.freeTripForDriver,
    required this.holdMoneyForTrip,
    required this.recordingVoice,
    required this.createdAt,
    required this.updatedAt,
    required this.rate,
    required this.expireAt,
    required this.startTime,
    required this.currencyEn,
    required this.currencyAr,
  });

  @override
  List<Object?> get props => [
        startLocation,
        targetLocation,
        tripRatingId,
        id,
        userId,
        riderId,
        subCategoryId,
        carTypeId,
        fromTitle,
        toTitle,
        profit,
        autoAccept,
        isPremium,
        distance,
        duration,
        passengers,
        price,
        calculateB,
        paymentMethod,
        status,
        penalty,
        payedPenalty,
        isUserGetCashback,
        isRiderGetCashback,
        otp,
        freeTripForDriver,
        holdMoneyForTrip,
        recordingVoice,
        createdAt,
        updatedAt,
        rate,
        expireAt,
        startTime,
        currencyEn,
        currencyAr
      ];
}
