class ClientPastTripEntity {
  final TripDetailsEntity? tripDetails;
  final bool? isButtonEnabled;
  final SubCategoryEntity? subCategory;
  final ClientDetailsEntity? clientDetails;
  final DriverDetailsEntity? driverDetails;

  ClientPastTripEntity({
    this.tripDetails,
    this.isButtonEnabled,
    this.subCategory,
    this.clientDetails,
    this.driverDetails,
  });
}

class TripDetailsEntity {
  final String? id;
  final num? price;
  final String? pickupTime;
  final String? status;
  final bool? isPremium;
  final String? note;
  final num? passengers;
  final LocationEntity? location;
  final RateEntity? yourRateDriver;
  final RateEntity? driverRateYou;
  final String? createdAt;

  TripDetailsEntity({
    this.id,
    this.price,
    this.pickupTime,
    this.status,
    this.isPremium,
    this.note,
    this.passengers,
    this.location,
    this.yourRateDriver,
    this.driverRateYou,
    this.createdAt,
  });
}

class LocationEntity {
  final String? fromTitle;
  final String? toTitle;

  LocationEntity({
    this.fromTitle,
    this.toTitle,
  });
}

class SubCategoryEntity {
  final String? id;
  final String? nameAr;
  final String? nameEn;
  final String? pictureUrl;

  SubCategoryEntity({
    this.id,
    this.nameAr,
    this.nameEn,
    this.pictureUrl,
  });
}

class ClientDetailsEntity {
  final String? id;
  final String? firstName;
  final String? profilePictureUrl;
  final bool? verifiedBadge;
  final RatingEntity? rating;

  ClientDetailsEntity({
    this.id,
    this.firstName,
    this.profilePictureUrl,
    this.verifiedBadge,
    this.rating,
  });
}

class DriverDetailsEntity {
  final String? id;
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? pictureUrl;
  final String? phoneNumber;
  final num? countTrips;
  final bool? verifiedBadge;
  final RatingEntity? rating;
  final VehicleDetailsEntity? vehicleDetails; // ✅ NEW

  DriverDetailsEntity({
    this.id,
    this.userId,
    this.firstName,
    this.pictureUrl,
    this.phoneNumber,
    this.rating,
    this.countTrips,
    this.vehicleDetails, // ✅ NEW
    this.verifiedBadge,
    this.lastName,
  });
}

class VehicleDetailsEntity {
  final String? brandAr;
  final String? brandEn;
  final String? modelAr;
  final String? modelEn;
  final String? color;
  final int? year;

  VehicleDetailsEntity({
    this.brandAr,
    this.brandEn,
    this.modelAr,
    this.modelEn,
    this.color,
    this.year,
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

class RateEntity {
  final int? rate;

  RateEntity({
    this.rate,
  });
}