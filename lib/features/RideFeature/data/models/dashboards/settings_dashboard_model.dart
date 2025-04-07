// driver_status_model.dart
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/settings_dashboard_entity.dart';

import 'sub_category_model.dart';

class SettingsDashboardModel extends SettingsDashboardEntity {
  SettingsDashboardModel({
    required super.isReady,
    required List<SubCategoryModel> super.categoryIds,
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
      categoryIds: List<SubCategoryModel>.from(
          (json['categoryIds'] as List).map((x) => SubCategoryModel.fromJson(x))),
      subscriptionType: json['subscriptionType'],
      pricingPerKm: json['pricingPerKm']!=null?json['pricingPerKm'].toDouble():0.0,
      city: json['city'],
      rating: RatingSettingsModel.fromJson(json['rating']),
      profit: json['profit']!=null?json['profit'].toDouble():0.0,
      countTrips: json['countTrips'],
      isActive: json['isActive'],
      isApproved: json['isApproved'],
      isRejected: json['isRejected'],
    );
  }
}

class RatingSettingsModel extends RatingSettingsEntity {
  RatingSettingsModel({required super.averageRating, required super.totalRatings});

  factory RatingSettingsModel.fromJson(Map<String, dynamic> json) {
    return RatingSettingsModel(
      averageRating: json['averageRating']!=null?json['averageRating'].toDouble():0.0,
      totalRatings: json['totalRatings'],
    );
  }
}

class SettingsDashboardResponseModel extends SettingsDashboardEntityResponse {
  SettingsDashboardResponseModel(
      {required super.status, required SettingsDashboardModel super.data});

  factory SettingsDashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return SettingsDashboardResponseModel(
      status: json['status'],
      data: SettingsDashboardModel.fromJson(json['data']),
    );
  }
}
