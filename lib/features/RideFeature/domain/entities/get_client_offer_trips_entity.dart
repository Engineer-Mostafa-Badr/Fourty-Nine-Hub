

class ClientOfferTripEntity {
  final String? id;
  final String? status;
  final num? price;
  final num? passengers;
  final num? newOfferPrice;
  final DriverDetailsEntity? driverDetails;
  final TripDetailsEntity? tripDetails;
  final bool isFromSocket;
  ClientOfferTripEntity({
    this.id,
    this.status,
    this.price,
    this.passengers,
    this.newOfferPrice,
    this.driverDetails,
    this.tripDetails,
    this.isFromSocket = false,
  });
}

class DriverDetailsEntity {
  final String? firstName;
  final String? lastName;
  final String? pictureUrl;
  final bool? verifiedBadge;
  final num? countTrips;
  final RatingEntity? rating;
  final VehicleDetailsEntity? vehicleDetails;

  DriverDetailsEntity({
    this.firstName,
    this.lastName,
    this.pictureUrl,
    this.countTrips,
    this.verifiedBadge,
    this.rating,
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

  RatingEntity({
    this.average,
    this.count,
  });
}

class TripDetailsEntity {
  final String? id;
  final int? passengers;
  final String? date;
  final LocationEntity? location;
  final SubcategoryEntity? subcategory;

  TripDetailsEntity({
    this.id,
    this.passengers,
    this.date,
    this.location,
    this.subcategory,
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

class SubcategoryEntity {
  final String? id;
  final String? nameAr;
  final String? nameEn;
  final String? pictureUrl;

  SubcategoryEntity({
    this.id,
    this.nameAr,
    this.nameEn,
    this.pictureUrl,
  });
}
