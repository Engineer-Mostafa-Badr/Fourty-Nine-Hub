import '../../../domain/entities/dashboards/get_past_ride_non_socket_trip_entity.dart';
import '../../../domain/entities/dashboards/get_past_ride_non_socket_trip_entity.dart';

class HistoryTripModel extends HistoryTripEntity {
  HistoryTripModel({
    super.clientDetails,
    super.subCategory,
    super.tripDetails,
    super.driverDetails,
  });

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
      driverDetails: json['driverDetails'] != null
          ? DriverDetailsModel.fromJson(json['driverDetails'])
          : null,
    );
  }
}

class ClientDetailsModel extends ClientDetailsEntity {
  ClientDetailsModel({
    super.id,
    super.firstName,
    super.profilePictureUrl,
    super.gender,
    super.verifiedBadge,
    super.rating,
  });

  factory ClientDetailsModel.fromJson(Map<String, dynamic> json) {
    return ClientDetailsModel(
      id: json['id'],
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

class DriverDetailsModel extends DriverDetailsEntity {
  DriverDetailsModel({
    super.id,
    super.driverUserId,
    super.firstName,
    super.profilePictureUrl,
    super.rating,
  });

  factory DriverDetailsModel.fromJson(Map<String, dynamic> json) {
    return DriverDetailsModel(
      id: json['id'],
      driverUserId: json['driverUserId'],
      firstName: json['firstName'],
      profilePictureUrl: json['profilePictureUrl'],
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : null,
    );
  }
}

class SubCategoryModel extends SubCategoryEntity {
  SubCategoryModel({
    super.id,
    super.nameEn,
    super.nameAr,
    super.pictureUrl,
  });

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
    super.createdAt,
    super.startLocation,
    super.targetLocation,
    super.yourRateClient,
    super.clientRateYou,
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
      yourRateClient: json['yourRateClient'] != null
          ? RateModel.fromJson(json['yourRateClient'])
          : null,
      clientRateYou: json['clientRateYou'] != null
          ? RateModel.fromJson(json['clientRateYou'])
          : null,
    );
  }
}

class LocationTitleModel extends LocationTitleEntity {
  LocationTitleModel({super.title});

  factory LocationTitleModel.fromJson(Map<String, dynamic> json) {
    return LocationTitleModel(title: json['title']);
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

class RateModel extends RateEntity {
  RateModel({super.rate});

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      rate: json['rate'],
    );
  }
}
