class DriverSettingsEntity {
  final String? id;
  final String? userId;
  final bool? isReady;
  final int? profit;
  final int? countTrips;
  final bool? isActive;
  final bool? isApproved;
  final bool? isRejected;
  final RatingEntity? rating;
  final CategoryEntity? category;
  final bool? isCriminalRecordEnabled;
  final bool? isDrugAnalysisRecordEnabled;
  final bool? isVehicleRecordEnabled;
  final String? idExpiryDate;
  final String? drivingLicenseExpiryDate;
  final String? carLicenseExpiryDate;
  final String? criminalRecordExpiryDate;
  final String? drugAnalysisExpiryDate;
  final String? technicalExaminationExpiryDate;

  DriverSettingsEntity({
    this.id,
    this.userId,
    this.isReady,
    this.profit,
    this.countTrips,
    this.isActive,
    this.isApproved,
    this.isRejected,
    this.rating,
    this.category,
    this.isCriminalRecordEnabled,
    this.isDrugAnalysisRecordEnabled,
    this.isVehicleRecordEnabled,
    this.idExpiryDate,
    this.drivingLicenseExpiryDate,
    this.carLicenseExpiryDate,
    this.criminalRecordExpiryDate,
    this.drugAnalysisExpiryDate,
    this.technicalExaminationExpiryDate,
  });
}

class RatingEntity {
  final double? average;
  final int? count;

  RatingEntity({
    this.average,
    this.count,
  });
}

class CategoryEntity {
  final SubCategoryEntity? subcategoryId;
  final String? nameEn;
  final String? nameAr;
  final String? pictureUrl;

  CategoryEntity({
    this.subcategoryId,
    this.nameEn,
    this.nameAr,
    this.pictureUrl,
  });
}

class SubCategoryEntity {
  final String? id;
  final String? picture;
  final String? nameAr;
  final String? nameEn;

  SubCategoryEntity({
    this.id,
    this.picture,
    this.nameAr,
    this.nameEn,
  });
}
