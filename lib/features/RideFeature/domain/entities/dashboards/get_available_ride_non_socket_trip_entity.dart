// Entity

class AvailableRideNonSocketTripEntity {
  final ClientDetailsEntity? clientDetails;
  final SubCategoryEntity? subCategory;
  final TripDetailsEntity? tripDetails;
  final StateEntity? state;

  AvailableRideNonSocketTripEntity({this.clientDetails, this.subCategory, this.tripDetails, this.state});
}

class ClientDetailsEntity {
  final String? id;
  final String? firstName;
  final String? profilePictureUrl;
  final String? gender;
  final RatingEntity? rating;

  ClientDetailsEntity({
    this.id,
    this.firstName,
    this.profilePictureUrl, this.gender, this.rating});
}

class RatingEntity {
  final num? average;
  final num? count;

  RatingEntity({this.average, this.count});
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
  final LocationEntity? startLocation;
  final LocationEntity? targetLocation;
  final String? createdAt;

  TripDetailsEntity({
    this.id,
    this.price,
    this.status,
    this.pickupTime,
    this.isPremium,
    this.passengers,
    this.note,
    this.startLocation,
    this.targetLocation,
    this.createdAt,
  });
}

class LocationEntity {
  final String? title;

  LocationEntity({this.title});
}

class StateEntity {
  final bool? isButtonEnabled;

  StateEntity({this.isButtonEnabled});
}
