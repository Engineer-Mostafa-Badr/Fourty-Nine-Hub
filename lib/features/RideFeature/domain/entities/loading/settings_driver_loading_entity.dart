class DriverSettingLoadingEntity {
  final String? id;
  final String? userId;
  final bool? isReady;
  final int? profit;
  final int? countTrips;
  final bool? isVoiceCommentAlertsEnabled;
  final RatingEntity? rating;
  final SubcategoryEntity? subcategory;
  final DocumentationsEntity? documentations;

  const DriverSettingLoadingEntity({
    this.id,
    this.userId,
    this.isReady,
    this.profit,
    this.countTrips,
    this.isVoiceCommentAlertsEnabled,
    this.rating,
    this.subcategory,
    this.documentations,
  });
}

class RatingEntity {
  final double? average;
  final int? count;

  const RatingEntity({
    this.average,
    this.count,
  });
}

class SubcategoryEntity {
  final String? subcategoryId;
  final String? nameAr;
  final String? nameEn;
  final String? pictureUrl;

  const SubcategoryEntity({
    this.subcategoryId,
    this.nameAr,
    this.nameEn,
    this.pictureUrl,
  });
}

class DocumentationsEntity {
  final DateTime? idExpiryDate;
  final DateTime? drivingLicenseExpiryDate;
  final DateTime? carLicenseExpiryDate;

  const DocumentationsEntity({
    this.idExpiryDate,
    this.drivingLicenseExpiryDate,
    this.carLicenseExpiryDate,
  });
}
