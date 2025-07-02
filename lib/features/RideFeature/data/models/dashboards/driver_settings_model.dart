import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/driver_settings_entity.dart';


class DriverSettingsModel extends DriverSettingsEntity {
  DriverSettingsModel({
    super.id,
    super.userId,
    super.isReady,
    super.profit,
    super.countTrips,
    super.isActive,
    super.isApproved,
    super.isRejected,
    super.isVoiceCommentAlertsEnabled,
    super.rating,
    super.category,
    super.fairCostPerKm,
    super.isCriminalRecordEnabled,
    super.isDrugAnalysisRecordEnabled,
    super.isVehicleRecordEnabled,
    super.idExpiryDate,
    super.drivingLicenseExpiryDate,
    super.carLicenseExpiryDate,
    super.criminalRecordExpiryDate,
    super.drugAnalysisExpiryDate,
    super.technicalExaminationExpiryDate,
  });

  factory DriverSettingsModel.fromJson(Map<String, dynamic> json) {
    final docs = json['documentations'];
    return DriverSettingsModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      isReady: json['isReady'] as bool?,
      profit: json['profit'] as int?,
      countTrips: json['countTrips'] as int?,
      isActive: json['isActive'] as bool?,
      isApproved: json['isApproved'] as bool?,
      isRejected: json['isRejected'] as bool?,
      isVoiceCommentAlertsEnabled: json['isVoiceCommentAlertsEnabled'] as bool?,
      rating: json['rating'] != null ? RatingModel.fromJson(json['rating']) : null,
      category: json['subcategory'] != null ? CategoryModel.fromJson(json['subcategory']) : null,
      fairCostPerKm: json['fairCostPerKm'] != null ? FairCostPerKmModel.fromJson(json['fairCostPerKm']) : null,
      carLicenseExpiryDate: docs?['carLicenseExpiryDate'],
      criminalRecordExpiryDate: docs?['criminalRecordExpiryDate'],
      drivingLicenseExpiryDate: docs?['drivingLicenseExpiryDate'],
      drugAnalysisExpiryDate: docs?['drugAnalysisExpiryDate'],
      idExpiryDate: docs?['idExpiryDate'],
      technicalExaminationExpiryDate: docs?['technicalExaminationExpiryDate'],
      isCriminalRecordEnabled: docs?['isCriminalRecordEnabled'],
      isDrugAnalysisRecordEnabled: docs?['isDrugAnalysisRecordEnabled'],
      isVehicleRecordEnabled: docs?['isVehicleRecordEnabled'],
    );
  }
}

class RatingModel extends RatingEntity {
  RatingModel({super.average, super.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: (json['average'] as num?)?.toDouble(),
      count: json['count'] as int?,
    );
  }
}

class CategoryModel extends CategoryEntity {
  CategoryModel({
    super.subcategoryId,
    super.nameEn,
    super.nameAr,
    super.pictureUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      subcategoryId: json['subcategoryId'] != null
          ? SubCategoryModel.fromJson(json['subcategoryId'])
          : null,
      nameEn: json['nameEn'] as String?,
      nameAr: json['nameAr'] as String?,
      pictureUrl: json['pictureUrl'] as String?,
    );
  }
}

class SubCategoryModel extends SubCategoryEntity {
  SubCategoryModel({
    super.id,
    super.picture,
    super.nameAr,
    super.nameEn,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'] as String?,
      picture: json['picture'] as String?,
      nameAr: json['nameAr'] as String?,
      nameEn: json['nameEn'] as String?,
    );
  }
}

class FairCostPerKmModel extends FairCostPerKmEntity {
  FairCostPerKmModel({super.highCostPerKm, super.lowCostPerKm});

  factory FairCostPerKmModel.fromJson(Map<String, dynamic> json) {
    return FairCostPerKmModel(
      highCostPerKm: json['highCostPerKm'] as int?,
      lowCostPerKm: json['lowCostPerKm'] as int?,
    );
  }
}
