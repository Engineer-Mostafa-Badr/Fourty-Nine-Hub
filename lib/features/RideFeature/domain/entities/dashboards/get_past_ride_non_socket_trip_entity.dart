// class HistoryTripEntity {
//   final ClientDetailsEntity? clientDetails;
//   final SubCategoryEntity? subCategory;
//   final TripDetailsEntity? tripDetails;
//
//   HistoryTripEntity({this.clientDetails, this.subCategory, this.tripDetails});
// }
//
// class ClientDetailsEntity {
//   final String? firstName;
//   final String? profilePictureUrl;
//   final String? gender;
//   final bool? verifiedBadge;
//   final RatingDetailEntity? rating;
//
//   ClientDetailsEntity({
//     this.firstName,
//     this.profilePictureUrl,
//     this.gender,
//     this.verifiedBadge,
//     this.rating,
//   });
// }
//
// // Keep all other entity classes exactly the same as you have them
// class SubCategoryEntity {
//   final String? id;
//   final String? nameEn;
//   final String? nameAr;
//   final String? pictureUrl;
//
//   SubCategoryEntity({this.id, this.nameEn, this.nameAr, this.pictureUrl});
// }
//
// class TripDetailsEntity {
//   final String? id;
//   final num? price;
//   final String? status;
//   final String? pickupTime;
//   final bool? isPremium;
//   final num? passengers;
//   final String? note;
//   final String? createdAt;
//   final LocationTitleEntity? startLocation;
//   final LocationTitleEntity? targetLocation;
//   final TripRatingEntity? rating;
//
//   TripDetailsEntity({
//     this.id,
//     this.price,
//     this.status,
//     this.pickupTime,
//     this.isPremium,
//     this.passengers,
//     this.note,
//     this.createdAt,
//     this.startLocation,
//     this.targetLocation,
//     this.rating,
//   });
// }
//
// class LocationTitleEntity {
//   final String? title;
//
//   LocationTitleEntity({this.title});
// }
//
// class TripRatingEntity {
//   final RatingDetailEntity? driver;
//   final RatingDetailEntity? client;
//
//   TripRatingEntity({this.driver, this.client});
// }
//
// class RatingDetailEntity {
//   final num? average;
//   final num? count;
//
//   RatingDetailEntity({this.average, this.count});
// }


class HistoryTripEntity {
  final ClientDetailsEntity? clientDetails;
  final SubCategoryEntity? subCategory;
  final TripDetailsEntity? tripDetails;

  HistoryTripEntity({this.clientDetails, this.subCategory, this.tripDetails});
}

class ClientDetailsEntity {
  final String? firstName;
  final String? profilePictureUrl;
  final String? gender;
  final bool? verifiedBadge;
  final RatingEntity? rating; // Changed to RatingEntity

  ClientDetailsEntity({
    this.firstName,
    this.profilePictureUrl,
    this.gender,
    this.verifiedBadge,
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
  final RatingEntity? yourRating; // Changed to RatingEntity

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
    this.yourRating,
  });
}

class LocationTitleEntity {
  final String? title;

  LocationTitleEntity({this.title});
}

// Unified rating entity (removed TripRatingEntity and RatingDetailEntity)
class RatingEntity {
  final num? average;
  final num? count;

  RatingEntity({this.average, this.count});
}
