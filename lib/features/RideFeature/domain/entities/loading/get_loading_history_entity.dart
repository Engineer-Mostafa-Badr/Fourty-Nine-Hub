class GetLoadingHistoryEntity {
  final TripDetailsHistoryEntity? tripDetails;
  final SubCategoryEntity? subCategory;
  final ClientDetailsEntity? clientDetails;
  final DriverDetailsEntity? driverDetails;

  const GetLoadingHistoryEntity({
    this.tripDetails,
    this.subCategory,
    this.clientDetails,
    this.driverDetails,
  });
}

class TripDetailsHistoryEntity {
  final String? id;
  final String? status;
  final bool? isPremium;
  final num? price;
  final String? cargoDescription;
  final String? pickupTime;
  final String? createdAt;
  final LocationTitleEntity? startLocation;
  final LocationTitleEntity? targetLocation;
  final RateEntity? yourRateClient;
  final RateEntity? clientRateYou;

  const TripDetailsHistoryEntity({
    this.id,
    this.status,
    this.isPremium,
    this.price,
    this.cargoDescription,
    this.pickupTime,
    this.createdAt,
    this.startLocation,
    this.targetLocation,
    this.yourRateClient,
    this.clientRateYou,
  });
}

class LocationTitleEntity {
  final String? title;

  const LocationTitleEntity({this.title});
}

class RateEntity {
  final num? rate;

  const RateEntity({this.rate});
}

class SubCategoryEntity {
  final String? id;
  final String? nameAr;
  final String? nameEn;
  final String? pictureUrl;

  const SubCategoryEntity({
    this.id,
    this.nameAr,
    this.nameEn,
    this.pictureUrl,
  });
}

class ClientDetailsEntity {
  final String? id;
  final String? firstName;
  final String? gender;
  final String? profilePictureUrl;
  final bool? verifiedBadge;
  final RatingEntity? rating;

  const ClientDetailsEntity({
    this.id,
    this.firstName,
    this.gender,
    this.profilePictureUrl,
    this.verifiedBadge,
    this.rating,
  });
}

class DriverDetailsEntity {
  final String? id;
  final String? driverUserId;
  final String? firsName;
  final String? profilePictureUrl;
  final RatingEntity? rating;

  const DriverDetailsEntity({
    this.id,
    this.driverUserId,
    this.firsName,
    this.profilePictureUrl,
    this.rating,
  });
}

class RatingEntity {
  final num? average;
  final int? count;

  const RatingEntity({this.average, this.count});
}
