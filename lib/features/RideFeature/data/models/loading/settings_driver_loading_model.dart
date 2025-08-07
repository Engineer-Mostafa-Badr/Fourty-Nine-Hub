import '../../../domain/entities/loading/settings_driver_loading_entity.dart';

class DriverSettingLoadingModel extends DriverSettingLoadingEntity {
  DriverSettingLoadingModel({
    super.id,
    super.userId,
    super.isReady,
    super.profit,
    super.countTrips,
    super.isVoiceCommentAlertsEnabled,
    super.rating,
    super.subcategory,
    super.documentations,
  });

  factory DriverSettingLoadingModel.fromJson(Map<String, dynamic> json) {
    return DriverSettingLoadingModel(
      id: json['id'],
      userId: json['userId'],
      isReady: json['isReady'],
      profit: json['profit'],
      countTrips: json['countTrips'],
      isVoiceCommentAlertsEnabled: json['isVoiceCommentAlertsEnabled'],
      rating: json['rating'] != null
          ? RatingEntity(
        average: (json['rating']['average'] as num?)?.toDouble(),
        count: json['rating']['count'],
      )
          : null,
      subcategory: json['subcategory'] != null
          ? SubcategoryEntity(
        subcategoryId: json['subcategory']['subcategoryId'],
        nameAr: json['subcategory']['nameAr'],
        nameEn: json['subcategory']['nameEn'],
        pictureUrl: json['subcategory']['pictureUrl'],
      )
          : null,
      documentations: json['documentations'] != null
          ? DocumentationsEntity(
        idExpiryDate: json['documentations']['idExpiryDate'] != null
            ? DateTime.tryParse(json['documentations']['idExpiryDate'])
            : null,
        drivingLicenseExpiryDate:
        json['documentations']['drivingLicenseExpiryDate'] != null
            ? DateTime.tryParse(json['documentations']
        ['drivingLicenseExpiryDate'])
            : null,
        carLicenseExpiryDate:
        json['documentations']['carLicenseExpiryDate'] != null
            ? DateTime.tryParse(
            json['documentations']['carLicenseExpiryDate'])
            : null,
      )
          : null,
    );
  }
}
