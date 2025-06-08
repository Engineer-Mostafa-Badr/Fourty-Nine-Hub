

import '../../domain/entities/get_client_offer_trips_entity.dart';

class ClientOfferTripModel extends ClientOfferTripEntity {
  ClientOfferTripModel({
    super.id,
    super.status,
    super.price,
    super.newOfferPrice,
    super.passengers,
    super.driverDetails,
    super.tripDetails,
  });

  factory ClientOfferTripModel.fromJson(Map<String, dynamic> json) {
    return ClientOfferTripModel(
      id: json['id'],
      status: json['status'],
      price: (json['price'] as num?),
      newOfferPrice: (json['newOfferPrice'] as num?),
      passengers: json['passengers']?.toInt(),

      driverDetails: json['driverDetails'] != null
          ? DriverDetailsModel.fromJson(json['driverDetails'])
          : null,
      tripDetails: json['tripDetails'] != null
          ? TripDetailsModel.fromJson(json['tripDetails'])
          : null,
    );
  }
}

class DriverDetailsModel extends DriverDetailsEntity {
  DriverDetailsModel({
    super.firstName,
    super.pictureUrl,
    super.rating,
    super.vehicleDetails,
  });

  factory DriverDetailsModel.fromJson(Map<String, dynamic> json) {
    return DriverDetailsModel(
      firstName: json['firstName'],
      pictureUrl: json['pictureUrl'],
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : null,
      vehicleDetails: json['vehicleDetails'] != null
          ? VehicleDetailsModel.fromJson(json['vehicleDetails'])
          : null,
    );
  }
}
class VehicleDetailsModel extends VehicleDetailsEntity {
  VehicleDetailsModel({
    super.brandAr,
    super.brandEn,
    super.modelAr,
    super.modelEn,
    super.color,
    super.year,
  });

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
  RatingModel({super.average, super.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: (json['average'] as num?)?.toDouble(),
      count: json['count'],
    );
  }
}

class TripDetailsModel extends TripDetailsEntity {
  TripDetailsModel({
    super.id,
    super.passengers,
    super.data,
    super.location,
    super.subcategory,
  });

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
    return TripDetailsModel(
      id: json['id'],
      passengers: json['passengers'],
      data: json['data'],
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      subcategory: json['subcategory'] != null
          ? SubcategoryModel.fromJson(json['subcategory'])
          : null,
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

class SubcategoryModel extends SubcategoryEntity {
  SubcategoryModel({
    super.id,
    super.nameAr,
    super.nameEn,
    super.pictureUrl,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      id: json['id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      pictureUrl: json['pictureUrl'],
    );
  }
}
