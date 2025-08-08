// driver_status.dart
import 'sub_category_entity.dart';

class SettingsDashboardEntity {
  final bool isReady;
  final bool isComfort;
  final bool isNonSmoking;
  final bool isCaptainShareEnabled;
  final bool enableNotificationSound;
  final List<SubCategoryEntity> categoryIds;
  final String subscriptionType;
  final num pricingPerKm;
  final num highCostPerKm;
  final num lowCostPerKm;
  final String city;
  final RatingSettingsEntity rating;
  final double profit;
  final int countTrips;
  final bool isActive;
  final bool isApproved;
  final bool isRejected;
  final bool isCriminalRecordEnabled;
  final bool isDrugAnalysisRecordEnabled;
  final bool isVehicleRecordEnabled;
  final String idExpiryDate;
  final String drivingLicenseExpiryDate;
  final String carLicenseExpiryDate;
  final String criminalRecordExpiryDate;
  final String drugAnalysisExpiryDate;
  final String technicalExaminationExpiryDate;
  final List<RequestEntity> requests;
  final List<ExpiredRecordEntity> expiredRecords;

  SettingsDashboardEntity( {
    required this.isReady,
    required this.isComfort,
    required this.isNonSmoking,
    required this.isCaptainShareEnabled,
    required this.enableNotificationSound,
    required this.categoryIds,
    required this.subscriptionType,
    required this.pricingPerKm,
    required this.highCostPerKm,
    required this.lowCostPerKm,
    required this.city,
    required this.rating,
    required this.profit,
    required this.countTrips,
    required this.isActive,
    required this.isApproved,
    required this.isRejected,
    required this.requests,
    required this.expiredRecords,
    required this.isCriminalRecordEnabled, required this.isDrugAnalysisRecordEnabled, required this.isVehicleRecordEnabled, required this.idExpiryDate, required this.drivingLicenseExpiryDate, required this.carLicenseExpiryDate, required this.criminalRecordExpiryDate, required this.drugAnalysisExpiryDate, required this.technicalExaminationExpiryDate,
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

class RequestEntity{
  final String requestId;
  final String recordName;
  final String expiryDate;
  final String status;

  RequestEntity({required this.requestId, required this.recordName, required this.expiryDate, required this.status});
}


class ExpiredRecordEntity{
  final String recordId;
  final String recordName;
  final String expiryDate;

  ExpiredRecordEntity({required this.recordId, required this.recordName, required this.expiryDate});
}