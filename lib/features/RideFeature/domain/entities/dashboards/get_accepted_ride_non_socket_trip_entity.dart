
class AcceptedRideNonSocketTripEntity {
  final TripDateEntity? tripDate;
  final ClientDetailsEntity? clientDetails;

  AcceptedRideNonSocketTripEntity({this.tripDate, this.clientDetails});
}

class TripDateEntity {
  final String? id;
  final String? status;
  final bool? isPremium;
  final num? price;
  final String? date;
  final String? note;
  final num? passengers;
  final LocationEntity? location;
  final CategoryEntity? category;
  final String? createdAt;

  TripDateEntity({
    this.id,
    this.status,
    this.isPremium,
    this.price,
    this.date,
    this.note,
    this.location,
    this.category,
    this.passengers,
    this.createdAt,
  });
}

class LocationEntity {
  final String? fromTitle;
  final String? toTitle;

  LocationEntity({this.fromTitle, this.toTitle});
}

class CategoryEntity {
  final String? nameAr;
  final String? nameEn;
  final String? picture;

  CategoryEntity({this.nameAr, this.nameEn, this.picture});
}

class ClientDetailsEntity {
  final String? firstName;
  final String? gender;
  final String? profilePictureKey;
  final bool? verifiedBadge;
  final RatingDetailEntity? rating;

  ClientDetailsEntity({
    this.firstName,
    this.gender,
    this.profilePictureKey,
    this.verifiedBadge,
    this.rating,
  });
}
class RatingDetailEntity {
  final num? average;
  final num? count;

  RatingDetailEntity({this.average, this.count});
}

