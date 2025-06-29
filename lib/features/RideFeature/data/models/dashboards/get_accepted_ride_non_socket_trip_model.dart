

import '../../../domain/entities/dashboards/get_accepted_ride_non_socket_trip_entity.dart';

class AcceptedRideNonSocketTripModel extends AcceptedRideNonSocketTripEntity {
  AcceptedRideNonSocketTripModel({super.tripDate, super.clientDetails});

  factory AcceptedRideNonSocketTripModel.fromJson(Map<String, dynamic> json) {
    return AcceptedRideNonSocketTripModel(
      tripDate:
      json['tripDate'] != null ? TripDateModel.fromJson(json['tripDate']) : null,
      clientDetails: json['clientDetails'] != null
          ? ClientDetailsModel.fromJson(json['clientDetails'])
          : null,
    );
  }
}

class TripDateModel extends TripDateEntity {
  TripDateModel({
    super.id,
    super.status,
    super.isPremium,
    super.price,
    super.date,
    super.note,
    super.location,
    super.passengers,
    super.category,
    super.createdAt,
  });

  factory TripDateModel.fromJson(Map<String, dynamic> json) {
    return TripDateModel(
      id: json['id'],
      status: json['status'],
      isPremium: json['isPremium'],
      price: json['price'],
      date: json['date'],
      note: json['note'],
      passengers: json['passengers'],
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      createdAt: json['createdAt'],
    );
  }
}

class LocationModel extends LocationEntity {
  LocationModel({super.fromTitle, super.toTitle});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      fromTitle: json['fromTitle'],
      toTitle: json['toTitle'],
    );
  }
}

class CategoryModel extends CategoryEntity {
  CategoryModel({super.nameAr, super.nameEn, super.picture});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      picture: json['picture'],
    );
  }
}

class ClientDetailsModel extends ClientDetailsEntity {
  ClientDetailsModel({
    super.firstName,
    super.gender,
    super.profilePictureKey,
    super.verifiedBadge,
    super.rating,
  });

  factory ClientDetailsModel.fromJson(Map<String, dynamic> json) {
    return ClientDetailsModel(
      firstName: json['firstName'],
      gender: json['gender'],
      profilePictureKey: json['profilePictureKey'],
      verifiedBadge: json['verifiedBadge'],
      rating: json['rating'] != null
          ? RatingDetailModel.fromJson(json['rating'])
          : null,
    );
  }
}


class RatingDetailModel extends RatingDetailEntity {
  RatingDetailModel({super.average, super.count});

  factory RatingDetailModel.fromJson(Map<String, dynamic> json) {
    return RatingDetailModel(
      average: json['average'],
      count: json['count'],
    );
  }
}
