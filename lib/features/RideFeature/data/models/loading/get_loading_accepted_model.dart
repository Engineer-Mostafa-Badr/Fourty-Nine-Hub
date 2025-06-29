class GetLoadingAcceptedEntity {
  final TripDetailsEntity? tripDetails;
  final ClientEntity? client;

  const GetLoadingAcceptedEntity({
    this.tripDetails,
    this.client,
  });
}

class TripDetailsEntity {
  final String? id;
  final String? status;
  final bool? isPremium;
  final num? price;
  final String? date;
  final String? cargoDescription;
  final String? createdAt;
  final LocationEntity? location;
  final CategoryEntity? category;

  const TripDetailsEntity({
    this.id,
    this.status,
    this.isPremium,
    this.price,
    this.date,
    this.cargoDescription,
    this.createdAt,
    this.location,
    this.category,
  });
}

class LocationEntity {
  final String? fromTitle;
  final String? toTitle;

  const LocationEntity({
    this.fromTitle,
    this.toTitle,
  });
}

class CategoryEntity {
  final String? id;
  final String? nameAr;
  final String? nameEn;
  final String? picture;

  const CategoryEntity({
    this.id,
    this.nameAr,
    this.nameEn,
    this.picture,
  });
}

class ClientEntity {
  final String? id;
  final String? firstName;
  final String? gender;
  final String? profilePictureKey;
  final RatingEntity? rating;

  const ClientEntity({
    this.id,
    this.firstName,
    this.gender,
    this.profilePictureKey,
    this.rating,
  });
}

class RatingEntity {
  final num? averageRating;
  final int? count;

  const RatingEntity({
    this.averageRating,
    this.count,
  });
}
