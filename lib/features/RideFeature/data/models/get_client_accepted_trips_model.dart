import '../../domain/entities/get_client_accepted_trips_entity.dart';

class ClientAcceptedTripModel extends ClientAcceptedTripEntity {
  ClientAcceptedTripModel({
    TripDetailsModel? super.tripDetails,
    super.isButtonEnabled,
    DriverDetailsModel? super.driverDetails,
  });

  factory ClientAcceptedTripModel.fromJson(Map<String, dynamic> json) {
    return ClientAcceptedTripModel(
      tripDetails: json['tripDetails'] != null
          ? TripDetailsModel.fromJson(json['tripDetails'])
          : null,
      isButtonEnabled: json['state'] != null
          ? json['state']['isButtonEnabled'] ?? false
          : false,
      driverDetails: json['driverDetails'] != null
          ? DriverDetailsModel.fromJson(json['driverDetails'])
          : null,
    );
  }
}

class TripDetailsModel extends TripDetailsEntity {
  TripDetailsModel({
    super.id,
    super.status,
    super.isPremium,
    super.price,
    num? passengers,
    super.date,
    super.note,
    LocationModel? super.location,
    CategoryModel? super.category,
    super.createdAt,
  });

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
    return TripDetailsModel(
      id: json['id'],
      status: json['status'],
      isPremium: json['isPremium'],
      price: json['price'],
      passengers: json['passengers']?.toInt(),
      date: json['date'],
      note: json['note'],
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
  CategoryModel({super.nameAr, super.id, super.nameEn, super.picture});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      picture: json['picture'] ?? json['pictureUrl'] ?? '',
    );
  }
}

class DriverDetailsModel extends DriverDetailsEntity {
  DriverDetailsModel({
    super.id,
    super.firstName,
    super.countTrips,
    super.phoneNumber,
    super.verifiedBadge,
    super.picture,
    super.lastName,
    RatingModel? super.rating,
    VehicleDetailsModel? super.vehicleDetails,
  });

  factory DriverDetailsModel.fromJson(Map<String, dynamic> json) {
    return DriverDetailsModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      countTrips: json['countTrips'] ?? 0,
      verifiedBadge: json['verifiedBadge'] ?? false,
      picture: json['picture'] ?? '',
      lastName: json['lastName'] ?? '',
      rating:
          json['rating'] != null ? RatingModel.fromJson(json['rating']) : null,
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
      average:
          json['average'] != null ? (json['average'] as num).toDouble() : null,
      count: json['count'] ?? json['total'] ?? 0,
    );
  }
}
