class ClientPastTripEntity {
  final TripDetailsEntity? tripDetails;
  final YourDetailsEntity? yourDetails;

  ClientPastTripEntity({
    this.tripDetails,
    this.yourDetails,
  });
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

  LocationEntity({
    this.fromTitle,
    this.toTitle,
  });
}

class CategoryEntity {
  final String? nameAr;
  final String? nameEn;
  final String? picture;

  CategoryEntity({
    this.nameAr,
    this.nameEn,
    this.picture,
  });
}

class YourDetailsEntity {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? pictureUrl;
  final RatingEntity? rating;

  YourDetailsEntity({
    this.id,
    this.firstName,
    this.lastName,
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

