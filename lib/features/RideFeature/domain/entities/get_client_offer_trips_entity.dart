

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
  final String? pictureUrl;
  final RatingEntity? rating;

  DriverDetailsEntity({
    this.firstName,
    this.pictureUrl,
    this.rating,
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
  final String? data;
  final LocationEntity? location;
  final SubcategoryEntity? subcategory;

  TripDetailsEntity({
    this.id,
    this.passengers,
    this.data,
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
