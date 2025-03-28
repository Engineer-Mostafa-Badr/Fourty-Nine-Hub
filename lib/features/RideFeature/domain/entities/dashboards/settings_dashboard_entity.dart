// driver_status.dart
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/setting_subcategory_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/setting_subcategory_entity.dart';

class SettingsDashboardEntity {
  final bool isReady;
  final List<SettingSubcategoryEntity> categoryIds;
  final String subscriptionType;
  final double pricingPerKm;
  final String city;
  final RatingSettingsEntity rating;
  final double profit;
  final int countTrips;
  final bool isActive;
  final bool isApproved;
  final bool isRejected;

  SettingsDashboardEntity({
    required this.isReady,
    required this.categoryIds,
    required this.subscriptionType,
    required this.pricingPerKm,
    required this.city,
    required this.rating,
    required this.profit,
    required this.countTrips,
    required this.isActive,
    required this.isApproved,
    required this.isRejected,
  });

  factory SettingsDashboardEntity.fromJson(Map<String, dynamic> json) {
    return SettingsDashboardEntity(
      isReady: json['isReady'],
      categoryIds: (json['categoryIds'] as List)
          .map((e) => SettingSubcategoryModel.fromJson(e))
          .toList(),
      subscriptionType: json['subscriptionType'],
      pricingPerKm: json['pricingPerKm'].toDouble(),
      city: json['city'],
      rating: RatingSettingsEntity.fromJson(json['rating']),
      profit: json['profit'].toDouble(),
      countTrips: json['countTrips'],
      isActive: json['isActive'],
      isApproved: json['isApproved'],
      isRejected: json['isRejected'],
    );
  }
}

// rating.dart
class RatingSettingsEntity {
  final double averageRating;
  final int totalRatings;

  RatingSettingsEntity({required this.averageRating, required this.totalRatings});

  factory RatingSettingsEntity.fromJson(Map<String, dynamic> json) {
    return RatingSettingsEntity(
      averageRating: json['averageRating'].toDouble(),
      totalRatings: json['totalRatings'],
    );
  }
}

// driver_status_response.dart
class SettingsDashboardEntityResponse {
  final bool status;
  final SettingsDashboardEntity data;

  SettingsDashboardEntityResponse({required this.status, required this.data});

  factory SettingsDashboardEntityResponse.fromJson(Map<String, dynamic> json) {
    return SettingsDashboardEntityResponse(
      status: json['status'],
      data: SettingsDashboardEntity.fromJson(json['data']),
    );
  }
}