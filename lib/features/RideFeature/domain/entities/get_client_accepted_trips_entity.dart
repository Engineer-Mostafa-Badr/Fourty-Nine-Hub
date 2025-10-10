class ClientAcceptedTripEntity {
  final TripDetailsEntity? tripDetails;
  final bool? isButtonEnabled;
  final DriverDetailsEntity? driverDetails;

  ClientAcceptedTripEntity({this.tripDetails,this.isButtonEnabled, this.driverDetails});
}

class TripDetailsEntity {
  final String? id;
  final String? status;
  final bool? isPremium;
  final num? price;
  final num? passengers;
  final String? date;
  final String? note;
  final LocationEntity? location;
  final CategoryEntity? category;
  final String? createdAt;

  TripDetailsEntity({
    this.id,
    this.status,
    this.isPremium,
    this.price,
    this.passengers,
    this.date,
    this.note,
    this.location,
    this.category,
    this.createdAt,
  });
}

class LocationEntity {
  final String? fromTitle;
  final String? toTitle;

  LocationEntity({this.fromTitle, this.toTitle});
}

class CategoryEntity {
  final String? id;
  final String? nameAr;
  final String? nameEn;
  final String? picture;

  CategoryEntity({this.nameAr,this.id, this.nameEn, this.picture});
}

class DriverDetailsEntity {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? picture;
  final bool? verifiedBadge;
  final num? countTrips;
  final RatingEntity? rating;
  final VehicleDetailsEntity? vehicleDetails;

  DriverDetailsEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.picture,
    this.rating,
    this.verifiedBadge,
    this.countTrips,
    this.vehicleDetails,

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

  RatingEntity({this.average, this.count});
}
