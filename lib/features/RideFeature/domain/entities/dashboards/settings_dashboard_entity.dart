// driver_status.dart
import 'sub_category_entity.dart';

class SettingsDashboardEntity {
  final bool isReady;
  final bool enableNotificationSound;
  final List<SubCategoryEntity> categoryIds;
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
    required this.enableNotificationSound,
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
}

// rating.dart
class RatingSettingsEntity {
  final double averageRating;
  final int totalRatings;

  RatingSettingsEntity({required this.averageRating, required this.totalRatings});
}

// driver_status_response.dart
class SettingsDashboardEntityResponse {
  final bool status;
  final SettingsDashboardEntity data;

  SettingsDashboardEntityResponse({required this.status, required this.data});
}