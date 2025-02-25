import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_statistics_entity.dart';

class RideDriverStatisticsModel extends RideDriverStatisticsEntity{
  RideDriverStatisticsModel({required super.deadlineSubscriptionRegular, required super.deadlineSubscriptionPremium, required super.deadlineId, required super.deadlineLicense, required super.deadLineDriverLicense, required super.tripCount, required super.profit, required super.totalRating, required super.freeRide, required super.workingType});

  //fromJson
  factory RideDriverStatisticsModel.fromJson(Map<String, dynamic> json) {
    return RideDriverStatisticsModel(
        deadlineSubscriptionRegular: json['deadlineSubscriptionRegular'] ?? 0,
        deadlineSubscriptionPremium: json['deadlineSubscriptionPremium'] ?? 0,
        deadlineId: json['deadlineId'] ?? 0,
        deadlineLicense: json['deadlineLicense'] ?? 0,
        deadLineDriverLicense: json['deadLineDriverLicense'] ?? 0,
        tripCount: json['tripCount'] ?? 0,
        profit: json['profit'] ?? 0,
        totalRating: json['totalRating'] ?? 0,
        freeRide: json['freeRide'] ?? false,
        workingType: json['workingType'] ?? "");
  }
}