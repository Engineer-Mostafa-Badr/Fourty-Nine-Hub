import '../../../domain/entities/dashboards/get_past_ride_non_socket_trip_entity.dart';
import '../../../domain/entities/dashboards/get_past_ride_non_socket_trip_entity.dart';

class HistoryTripModel extends HistoryTripEntity {
  HistoryTripModel({super.clientDetails, super.subCategory, super.tripDetails});

  factory HistoryTripModel.fromJson(Map<String, dynamic> json) {
    return HistoryTripModel(
      clientDetails: json['clientDetails'] != null
          ? ClientDetailsModel.fromJson(json['clientDetails'])
          : null,
      subCategory: json['subCategory'] != null
          ? SubCategoryModel.fromJson(json['subCategory'])
          : null,
      tripDetails: json['tripDetails'] != null
          ? TripDetailsModel.fromJson(json['tripDetails'])
          : null,
    );
  }
}

class ClientDetailsModel extends ClientDetailsEntity {
  ClientDetailsModel({
    super.firstName,
    super.profilePictureUrl,
    super.gender,
    super.verifiedBadge,
    super.rating,
  });

  factory ClientDetailsModel.fromJson(Map<String, dynamic> json) {
    return ClientDetailsModel(
      firstName: json['firstName'],
      profilePictureUrl: json['profilePictureUrl'],
      gender: json['gender'],
      verifiedBadge: json['verifiedBadge'],
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : null,
    );
  }
}

class SubCategoryModel extends SubCategoryEntity {
  SubCategoryModel({super.id, super.nameEn, super.nameAr, super.pictureUrl});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    // The picture URL might be stored in an unusual way - we need to find it
    String? pictureUrl;

    // Look for a value that's a string URL
    for (var value in json.values) {
      if (value is String && value.startsWith('http')) {
        pictureUrl = value;
        break;
      }
    }

    return SubCategoryModel(
      id: json['id'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      pictureUrl: pictureUrl,
    );
  }
}

class TripDetailsModel extends TripDetailsEntity {
  TripDetailsModel({
    super.id,
    super.price,
    super.status,
    super.pickupTime,
    super.isPremium,
    super.passengers,
    super.note,
    super.createdAt,
    super.startLocation,
    super.targetLocation,
    super.yourRating,
  });

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
    return TripDetailsModel(
      id: json['id'],
      price: json['price'],
      status: json['status'],
      pickupTime: json['pickupTime'],
      isPremium: json['isPremium'],
      passengers: json['passengers'],
      note: json['note'],
      createdAt: json['createdAt'],
      startLocation: json['startLocation'] != null
          ? LocationTitleModel.fromJson(json['startLocation'])
          : null,
      targetLocation: json['targetLocation'] != null
          ? LocationTitleModel.fromJson(json['targetLocation'])
          : null,
      yourRating: json['yourRating'] != null
          ? RatingModel.fromJson(json['yourRating'])
          : null,
    );
  }
}

class LocationTitleModel extends LocationTitleEntity {
  LocationTitleModel({super.title});

  factory LocationTitleModel.fromJson(Map<String, dynamic> json) {
    return LocationTitleModel(
      title: json['title'],
    );
  }
}

class RatingModel extends RatingEntity {
  RatingModel({super.average, super.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: json['average'],
      count: json['count'],
    );
  }
}

// class HistoryTripModel extends HistoryTripEntity {
//   HistoryTripModel({super.clientDetails, super.subCategory, super.tripDetails});
//
//   factory HistoryTripModel.fromJson(Map<String, dynamic> json) {
//     return HistoryTripModel(
//       clientDetails: json['clientDetails'] != null
//           ? ClientDetailsModel.fromJson(json['clientDetails'])
//           : null,
//       subCategory: json['subCategory'] != null
//           ? SubCategoryModel.fromJson(json['subCategory'])
//           : null,
//       tripDetails: json['tripDetails'] != null
//           ? TripDetailsModel.fromJson(json['tripDetails'])
//           : null,
//     );
//   }
// }
//
// class ClientDetailsModel extends ClientDetailsEntity {
//   ClientDetailsModel({
//     super.firstName,
//     super.profilePictureUrl,
//     super.gender,
//     super.verifiedBadge,
//     super.rating,
//   });
//
//   factory ClientDetailsModel.fromJson(Map<String, dynamic> json) {
//     return ClientDetailsModel(
//       firstName: json['firstName'],
//       profilePictureUrl: json['profilePictureUrl'],
//       gender: json['gender'],
//       verifiedBadge: json['verifiedBadge'],
//       rating: json['rating'] != null
//           ? RatingDetailModel.fromJson(json['rating'])
//           : null,
//     );
//   }
// }
//
// // Keep all other model classes exactly the same as you have them
// class SubCategoryModel extends SubCategoryEntity {
//   SubCategoryModel({super.id, super.nameEn, super.nameAr, super.pictureUrl});
//
//   factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
//     return SubCategoryModel(
//       id: json['id'],
//       nameEn: json['nameEn'],
//       nameAr: json['nameAr'],
//       pictureUrl: json['pictureUrl'],
//     );
//   }
// }
//
// class TripDetailsModel extends TripDetailsEntity {
//   TripDetailsModel({
//     super.id,
//     super.price,
//     super.status,
//     super.pickupTime,
//     super.isPremium,
//     super.passengers,
//     super.note,
//     super.createdAt,
//     super.startLocation,
//     super.targetLocation,
//     super.rating,
//   });
//
//   factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
//     return TripDetailsModel(
//       id: json['id'],
//       price: json['price'],
//       status: json['status'],
//       pickupTime: json['pickupTime'],
//       isPremium: json['isPremium'],
//       passengers: json['passengers'],
//       note: json['note'],
//       createdAt: json['createdAt'],
//       startLocation: json['startLocation'] != null
//           ? LocationTitleModel.fromJson(json['startLocation'])
//           : null,
//       targetLocation: json['targetLocation'] != null
//           ? LocationTitleModel.fromJson(json['targetLocation'])
//           : null,
//       rating: json['rating'] != null
//           ? TripRatingModel.fromJson(json['rating'])
//           : null,
//     );
//   }
// }
//
// class LocationTitleModel extends LocationTitleEntity {
//   LocationTitleModel({super.title});
//
//   factory LocationTitleModel.fromJson(Map<String, dynamic> json) {
//     return LocationTitleModel(
//       title: json['title'],
//     );
//   }
// }
//
// class TripRatingModel extends TripRatingEntity {
//   TripRatingModel({super.driver, super.client});
//
//   factory TripRatingModel.fromJson(Map<String, dynamic> json) {
//     return TripRatingModel(
//       driver: json['driver'] != null
//           ? RatingDetailModel.fromJson(json['driver'])
//           : null,
//       client: json['client'] != null
//           ? RatingDetailModel.fromJson(json['client'])
//           : null,
//     );
//   }
// }
//
// class RatingDetailModel extends RatingDetailEntity {
//   RatingDetailModel({super.average, super.count});
//
//   factory RatingDetailModel.fromJson(Map<String, dynamic> json) {
//     return RatingDetailModel(
//       average: json['average'],
//       count: json['count'],
//     );
//   }
// }