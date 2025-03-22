// driver_status_model.dart
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/settings_dashboard_entity.dart';

class SettingsDashboardModel extends SettingsDashboardEntity {
  SettingsDashboardModel({
    required super.isReady,
    required super.categoryIds,
    required super.subscriptionType,
    required super.pricingPerKm,
    required super.city,
    required RatingSettingsModel super.rating,
    required super.profit,
    required super.countTrips,
    required super.isActive,
    required super.isApproved,
    required super.isRejected,
  });

  factory SettingsDashboardModel.fromJson(Map<String, dynamic> json) {
    return SettingsDashboardModel(
      isReady: json['isReady'],
      categoryIds: List<String>.from(json['categoryIds']),
      subscriptionType: json['subscriptionType'],
      pricingPerKm: json['pricingPerKm'].toDouble(),
      city: json['city'],
      rating: RatingSettingsModel.fromJson(json['rating']),
      profit: json['profit'].toDouble(),
      countTrips: json['countTrips'],
      isActive: json['isActive'],
      isApproved: json['isApproved'],
      isRejected: json['isRejected'],
    );
  }
}

// rating_model.dart
class RatingSettingsModel extends RatingSettingsEntity {
  RatingSettingsModel({required super.averageRating, required super.totalRatings});

  factory RatingSettingsModel.fromJson(Map<String, dynamic> json) {
    return RatingSettingsModel(
      averageRating: json['averageRating'].toDouble(),
      totalRatings: json['totalRatings'],
    );
  }
}

// driver_status_response_model.dart
class DriverStatusResponseModel extends SettingsDashboardEntityResponse {
  DriverStatusResponseModel(
      {required super.status, required SettingsDashboardModel super.data});

  factory DriverStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return DriverStatusResponseModel(
      status: json['status'],
      data: SettingsDashboardModel.fromJson(json['data']),
    );
  }
}
