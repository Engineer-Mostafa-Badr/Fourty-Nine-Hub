
import '../../domain/entities/get_client_past_trips_entity.dart';


class ClientPastTripModel extends ClientPastTripEntity {
  ClientPastTripModel({
    super.tripDetails,
    super.subCategory,
    super.clientDetails,
    super.driverDetails,
  });

  factory ClientPastTripModel.fromJson(Map<String, dynamic> json) {
    return ClientPastTripModel(
      tripDetails: json['tripDetails'] != null
          ? TripDetailsModel.fromJson(json['tripDetails'])
          : null,
      subCategory: json['subCategory'] != null
          ? SubCategoryModel.fromJson(json['subCategory'])
          : null,
      clientDetails: json['clientDetails'] != null
          ? ClientDetailsModel.fromJson(json['clientDetails'])
          : null,
      driverDetails: json['driverDetails'] != null
          ? DriverDetailsModel.fromJson(json['driverDetails'])
          : null,
    );
  }
}

class TripDetailsModel extends TripDetailsEntity {
  TripDetailsModel({
    super.id,
    super.price,
    super.pickupTime,
    super.status,
    super.isPremium,
    super.note,
    super.passengers,
    super.location,
    super.yourRateDriver,
    super.driverRateYou,
    super.createdAt,
  });

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
    return TripDetailsModel(
      id: json['id'],
      price: json['price']?.toDouble(),
      pickupTime: json['pickupTime'],
      status: json['status'],
      isPremium: json['isPremium'],
      note: json['note'],
      passengers: json['passengers']?.toInt(),
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      yourRateDriver: json['yourRateDriver'] != null
          ? RateModel.fromJson(json['yourRateDriver'])
          : null,
      driverRateYou: json['driverRateYou'] != null
          ? RateModel.fromJson(json['driverRateYou'])
          : null,
      createdAt: json['createdAt'],
    );
  }
}

class LocationModel extends LocationEntity {
  LocationModel({
    super.fromTitle,
    super.toTitle,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      fromTitle: json['fromTitle'],
      toTitle: json['toTitle'],
    );
  }
}

class SubCategoryModel extends SubCategoryEntity {
  SubCategoryModel({
    super.id,
    super.nameAr,
    super.nameEn,
    super.pictureUrl,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      pictureUrl: json['pictureUrl'],
    );
  }
}

class ClientDetailsModel extends ClientDetailsEntity {
  ClientDetailsModel({
    super.id,
    super.firstName,
    super.profilePictureUrl,
    super.verifiedBadge,
    super.rating,
  });

  factory ClientDetailsModel.fromJson(Map<String, dynamic> json) {
    return ClientDetailsModel(
      id: json['id'],
      firstName: json['firstName'],
      profilePictureUrl: json['profilePictureUrl'],
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
    super.firstName,
    super.pictureUrl,
    super.rating,
  });

  factory DriverDetailsModel.fromJson(Map<String, dynamic> json) {
    return DriverDetailsModel(
      id: json['id'],
      firstName: json['firstName'],
      pictureUrl: json['pictureUrl'],
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : null,
    );
  }
}

class RatingModel extends RatingEntity {
  RatingModel({
    super.average,
    super.count,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: json['average']?.toDouble(),
      count: json['count']?.toInt(),
    );
  }
}

class RateModel extends RateEntity {
  RateModel({
    super.rate,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      rate: json['rate']?.toInt(),
    );
  }
}