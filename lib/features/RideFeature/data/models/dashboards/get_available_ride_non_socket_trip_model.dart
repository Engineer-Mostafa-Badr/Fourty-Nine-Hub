// Model

import '../../../domain/entities/dashboards/get_available_ride_non_socket_trip_entity.dart';

class GetAvailableRideNonSocketTripModel extends AvailableRideNonSocketTripEntity {
  GetAvailableRideNonSocketTripModel({super.clientDetails, super.subCategory, super.tripDetails, super.state});

  factory GetAvailableRideNonSocketTripModel.fromJson(Map<String, dynamic> json) {
    return GetAvailableRideNonSocketTripModel(
      clientDetails: json['clientDetails'] != null
          ? ClientDetailsModel.fromJson(json['clientDetails'])
          : null,
      subCategory: json['subCategory'] != null
          ? SubCategoryModel.fromJson(json['subCategory'])
          : null,
      tripDetails: json['tripDetails'] != null
          ? TripDetailsModel.fromJson(json['tripDetails'])
          : null,
      state: json['state'] != null ? StateModel.fromJson(json['state']) : null,
    );
  }
}

class ClientDetailsModel extends ClientDetailsEntity {
  ClientDetailsModel({super.firstName, super.profilePictureUrl, super.gender, super.rating});

  factory ClientDetailsModel.fromJson(Map<String, dynamic> json) {
    return ClientDetailsModel(
      firstName: json['firstName'],
      profilePictureUrl: json['profilePictureUrl'],
      gender: json['gender'],
      rating: json['rating'] != null ? RatingModel.fromJson(json['rating']) : null,
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

class SubCategoryModel extends SubCategoryEntity {
  SubCategoryModel({super.id, super.nameEn, super.nameAr, super.pictureUrl});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      pictureUrl: json['pictureUrl'],
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
    super.startLocation,
    super.targetLocation,
    super.createdAt,
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
      startLocation: json['startLocation'] != null
          ? LocationModel.fromJson(json['startLocation'])
          : null,
      targetLocation: json['targetLocation'] != null
          ? LocationModel.fromJson(json['targetLocation'])
          : null,
      createdAt: json['createdAt'],
    );
  }
}

class LocationModel extends LocationEntity {
  LocationModel({super.title});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      title: json['title'],
    );
  }
}

class StateModel extends StateEntity {
  StateModel({super.isButtonEnabled});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      isButtonEnabled: json['isButtonEnabled'],
    );
  }
}
