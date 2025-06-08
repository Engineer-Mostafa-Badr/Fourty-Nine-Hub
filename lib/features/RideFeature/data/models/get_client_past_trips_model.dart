
import '../../domain/entities/get_client_past_trips_entity.dart';


class ClientPastTripModel extends ClientPastTripEntity {
  ClientPastTripModel({
    super.tripDetails,
    super.yourDetails,
    super.subCategory,
    super.clientDetails,
    super.driverDetails,
  });

  factory ClientPastTripModel.fromJson(Map<String, dynamic> json) {
    return ClientPastTripModel(
      tripDetails: json['tripDetails'] != null
          ? TripDetailsModel.fromJson(json['tripDetails'])
          : null,
      yourDetails: json['yourDetails'] != null
          ? YourDetailsModel.fromJson(json['yourDetails'])
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
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : json['subCategory'] != null?CategoryModel.fromJson(json['subCategory']):null,
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
      id: json['id']??'',
      nameAr: json['nameAr']??'',
      nameEn: json['nameEn']??'',
      pictureUrl: json['pictureUrl']??json['picture']??'',
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
    String? id,
    String? userId,
    String? firstName,
    String? pictureUrl,
    RatingModel? rating,
    VehicleDetailsModel? vehicleDetails, // ✅ NEW
  }) : super(
    id: id,
    userId: userId,
    firstName: firstName,
    pictureUrl: pictureUrl,
    rating: rating,
    vehicleDetails: vehicleDetails, // ✅ NEW
  );

  factory DriverDetailsModel.fromJson(Map<String, dynamic> json) {
    return DriverDetailsModel(
      id: json['id'],
      userId: json['userId'],
      firstName: json['firstName'],
      pictureUrl: json['pictureUrl'],
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : null,
      vehicleDetails: json['vehicleDetails'] != null
          ? VehicleDetailsModel.fromJson(json['vehicleDetails'])
          : null, // ✅ PARSE
    );
  }
}

class VehicleDetailsModel extends VehicleDetailsEntity {
  VehicleDetailsModel({
    String? brandAr,
    String? brandEn,
    String? modelAr,
    String? modelEn,
    String? color,
    int? year,
  }) : super(
    brandAr: brandAr,
    brandEn: brandEn,
    modelAr: modelAr,
    modelEn: modelEn,
    color: color,
    year: year,
  );

  factory VehicleDetailsModel.fromJson(Map<String, dynamic> json) {
    return VehicleDetailsModel(
      brandAr: json['brandAr'],
      brandEn: json['brandEn'],
      modelAr: json['modelAr'],
      modelEn: json['modelEn'],
      color: json['color'],
      year: json['year'],
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