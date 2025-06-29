class HistoryTripEntity {
  final ClientDetailsEntity? clientDetails;
  final SubCategoryEntity? subCategory;
  final TripDetailsEntity? tripDetails;
  final DriverDetailsEntity? driverDetails;

  HistoryTripEntity({
    this.clientDetails,
    this.subCategory,
    this.tripDetails,
    this.driverDetails,
  });
}

class ClientDetailsEntity {
  final String? id;
  final String? firstName;
  final String? profilePictureUrl;
  final String? gender;
  final bool? verifiedBadge;
  final RatingEntity? rating;

  ClientDetailsEntity({
    this.id,
    this.firstName,
    this.profilePictureUrl,
    this.gender,
    this.verifiedBadge,
    this.rating,
  });
}

class DriverDetailsEntity {
  final String? id;
  final String? driverUserId;
  final String? firstName;
  final String? profilePictureUrl;
  final RatingEntity? rating;

  DriverDetailsEntity({
    this.id,
    this.driverUserId,
    this.firstName,
    this.profilePictureUrl,
    this.rating,
  });
}

class SubCategoryEntity {
  final String? id;
  final String? nameEn;
  final String? nameAr;
  final String? pictureUrl;

  SubCategoryEntity({this.id, this.nameEn, this.nameAr, this.pictureUrl});
}

class TripDetailsEntity {
  final String? id;
  final num? price;
  final String? status;
  final String? pickupTime;
  final bool? isPremium;
  final num? passengers;
  final String? note;
  final String? createdAt;
  final LocationTitleEntity? startLocation;
  final LocationTitleEntity? targetLocation;
  final RateEntity? yourRateClient; // Changed from yourRating
  final RateEntity? clientRateYou; // New field

  TripDetailsEntity({
    this.id,
    this.price,
    this.status,
    this.pickupTime,
    this.isPremium,
    this.passengers,
    this.note,
    this.createdAt,
    this.startLocation,
    this.targetLocation,
    this.yourRateClient,
    this.clientRateYou,
  });
}

class LocationTitleEntity {
  final String? title;

  LocationTitleEntity({this.title});
}

class RatingEntity {
  final num? average;
  final num? count;

  RatingEntity({this.average, this.count});
}

class RateEntity {
  final num? rate;

  RateEntity({this.rate});
}