// driver_status_model.dart
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/settings_dashboard_entity.dart';

import 'sub_category_model.dart';

class SettingsDashboardModel extends SettingsDashboardEntity {
  SettingsDashboardModel({
    required super.isReady,
    required super.isCaptainShareEnabled,
    required super.enableNotificationSound,
    required List<SubCategoryModel> super.categoryIds,
    required super.subscriptionType,
    required super.pricingPerKm,
    required super.highCostPerKm,
    required super.lowCostPerKm,
    required super.city,
    required RatingSettingsModel super.rating,
    required super.profit,
    required super.countTrips,
    required super.isActive,
    required super.isApproved,
    required super.isRejected,
    required super.requests,
    required super.expiredRecords,
    required super.isCriminalRecordEnabled, required super.isDrugAnalysisRecordEnabled, required super.isVehicleRecordEnabled, required super.idExpiryDate, required super.drivingLicenseExpiryDate, required super.carLicenseExpiryDate, required super.criminalRecordExpiryDate, required super.drugAnalysisExpiryDate, required super.technicalExaminationExpiryDate,
  });

  factory SettingsDashboardModel.fromJson(Map<String, dynamic> json) {
    return SettingsDashboardModel(
      isReady: json['isReady']??false,
      enableNotificationSound: json['isVoiceCommentAlertsEnabled']??false,
      isCaptainShareEnabled: json['isCaptainShareEnabled']??false,
      categoryIds: List<SubCategoryModel>.from((json['categoryIds'] as List)
          .map((x) => SubCategoryModel.fromJson(x))),
      requests: List<RequestModel>.from((json['requests'] as List)
          .map((x) => RequestModel.fromJson(x))),
      expiredRecords: List<ExpiredRecordsModel>.from((json['expiredRecords'] as List)
          .map((x) => ExpiredRecordsModel.fromJson(x))),
      subscriptionType: json['subscriptionType'],
      pricingPerKm: json['pricingPerKm']!=null?json['pricingPerKm'].toDouble():0.0,
      highCostPerKm: json['fairCostPerKm']!=null?json['fairCostPerKm']['highCostPerKm']??0.0:0.0,
      lowCostPerKm: json['fairCostPerKm']!=null?json['fairCostPerKm']['lowCostPerKm']??0.0:0.0,
      city: json['city'],
      rating: RatingSettingsModel.fromJson(json['rating']),
      profit: json['profit']!=null?json['profit'].toDouble():0.0,
      countTrips: json['countTrips'],
      isActive: json['isActive'],
      isApproved: json['isApproved'],
      isRejected: json['isRejected'],
      carLicenseExpiryDate: json['documentations']!=null?json['documentations']['carLicenseExpiryDate']??'':'',
      criminalRecordExpiryDate: json['documentations']!=null?json['documentations']['criminalRecordExpiryDate']??'':'',
      drivingLicenseExpiryDate: json['documentations']!=null?json['documentations']['drivingLicenseExpiryDate']??'':'',
      drugAnalysisExpiryDate: json['documentations']!=null?json['documentations']['drugAnalysisExpiryDate']??'':'',
      idExpiryDate: json['documentations']!=null?json['documentations']['idExpiryDate']??'':'',
      isCriminalRecordEnabled: json['documentations']!=null?json['documentations']['isCriminalRecordEnabled']??false:false,
      isDrugAnalysisRecordEnabled: json['documentations']!=null?json['documentations']['isDrugAnalysisRecordEnabled']??false:false,
      isVehicleRecordEnabled: json['documentations']!=null?json['documentations']['isVehicleRecordEnabled']??false:false,
      technicalExaminationExpiryDate: json['documentations']!=null?json['documentations']['technicalExaminationExpiryDate']??'':'',
    );
  }
}

class RatingSettingsModel extends RatingSettingsEntity {
  RatingSettingsModel(
      {required super.averageRating, required super.totalRatings});

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


class RequestModel extends RequestEntity {
  RequestModel({required super.requestId, required super.recordName, required super.expiryDate, required super.status});

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      requestId: json['requestId'],
      recordName: json['recordName'],
      expiryDate: json['expiryDate'],
      status: json['status'],
    );
  }
}

class ExpiredRecordsModel extends ExpiredRecordEntity {
  ExpiredRecordsModel({required super.recordId, required super.recordName, required super.expiryDate});

  factory ExpiredRecordsModel.fromJson(Map<String, dynamic> json) {
    return ExpiredRecordsModel(
      recordId: json['recordId'],
      recordName: json['recordName'],
      expiryDate: json['expiryDate'],
    );
  }
}
