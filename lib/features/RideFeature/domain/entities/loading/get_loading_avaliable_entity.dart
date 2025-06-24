class GetLoadingAvailableEntity {
  final TripDetailsHistoryEntity? tripDetails;
  final SubCategoryEntity? subCategory;
  final ClientDetailsEntity? clientDetails;
  final String? createdAt;
  final TripStateEntity? state;

  const GetLoadingAvailableEntity({
    this.tripDetails,
    this.subCategory,
    this.clientDetails,
    this.createdAt,
    this.state,
  });
}

class TripDetailsHistoryEntity {
  final String? id;
  final bool? isPremium;
  final num? price;
  final String? cargoDescription;
  final String? pickupTime;
  final String? status;
  final LocationTitleEntity? startLocation;
  final LocationTitleEntity? targetLocation;

  const TripDetailsHistoryEntity({
    this.id,
    this.isPremium,
    this.price,
    this.cargoDescription,
    this.pickupTime,
    this.status,
    this.startLocation,
    this.targetLocation,
  });
}

class LocationTitleEntity {
  final String? title;

  const LocationTitleEntity({this.title});
}

class SubCategoryEntity {
  final String? id;
  final String? nameEn;
  final String? nameAr;
  final String? pictureUrl;

  const SubCategoryEntity({
    this.id,
    this.nameEn,
    this.nameAr,
    this.pictureUrl,
  });
}

class ClientDetailsEntity {
  final String? id;
  final String? firstName;
  final String? gender;
  final String? profilePictureUrl;
  final RatingEntity? rating;

  const ClientDetailsEntity({
    this.id,
    this.firstName,
    this.gender,
    this.profilePictureUrl,
    this.rating,
  });
}

class RatingEntity {
  final num? average;
  final int? count;

  const RatingEntity({this.average, this.count});
}

class TripStateEntity {
  final bool? isButtonEnabled;

  const TripStateEntity({this.isButtonEnabled});
}
