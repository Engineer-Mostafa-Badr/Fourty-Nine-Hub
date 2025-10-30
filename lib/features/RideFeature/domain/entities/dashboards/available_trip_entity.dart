import 'package:google_maps_flutter/google_maps_flutter.dart';

class AvailableTripEntity {
  final String? id;
  final bool? autoAcceptEnabled;
  final bool? isAutoAccept;
  final bool? isPremium;
  final bool? isComfort;
  final bool? isNonSmoking;
  double? price;
  num? lastOffer;
  final num? platformFee;
  final String? paymentMethod;
  final String? description;
  final DateTime? createdAt;
  final AvailableTripSubcategoryEntity? subcategory;
  final AvailableTripRouteEntity? route;
  final AvailableTripStateEntity? state;
  final OfferPriceRangeEntity? offerPriceRange;
  final ClientDetailsEntity? clientDetails;

  AvailableTripEntity({
    this.id,
    this.autoAcceptEnabled,
    this.isAutoAccept,
    this.isPremium,
    this.isComfort,
    this.isNonSmoking,
    this.price,
    this.lastOffer,
    this.platformFee,
    this.paymentMethod,
    this.description,
    this.createdAt,
    this.subcategory,
    this.route,
    this.offerPriceRange,
    this.state,
    this.clientDetails,
  });
}

// ---- Subcategory Entity ----
class AvailableTripSubcategoryEntity {
  final String? id;
  final String? nameAr;
  final String? nameEn;
  final String? imageUrl;

  AvailableTripSubcategoryEntity({this.id, this.nameAr, this.nameEn, this.imageUrl});
}

// ---- Trip Route Entity ----
class AvailableTripRouteEntity {
  final List<LatLng>? pickupToDropPolyline;
  final DriverPositionEntity? driverPosition;
  final TripPointEntity? pickupPoint;
  final TripPointEntity? dropPoint;

  AvailableTripRouteEntity({
    this.pickupToDropPolyline,
    this.driverPosition,
    this.pickupPoint,
    this.dropPoint,
  });
}

// ---- Driver Position Entity ----
class DriverPositionEntity {
  final double? longitude;
  final double? latitude;
  final double? distanceToPickup;
  final double? durationToPickup;

  DriverPositionEntity({
    this.longitude,
    this.latitude,
    this.distanceToPickup,
    this.durationToPickup,
  });
}

// ---- Trip Point Entity ----
class TripPointEntity {
  final String? address;
  final double? longitude;
  final double? latitude;
  final double? distanceFromPickup;
  final double? durationFromPickup;

  TripPointEntity({
    this.address,
    this.longitude,
    this.latitude,
    this.distanceFromPickup,
    this.durationFromPickup,
  });
}

// ---- Trip State Entity ----
class AvailableTripStateEntity {
  final bool? isButtonEnabled;

  AvailableTripStateEntity({this.isButtonEnabled});
}

class OfferPriceRangeEntity {
  final num? lowestFare;
  final num? highestFare;

  OfferPriceRangeEntity({required this.lowestFare,required this.highestFare});
}

class ClientDetailsEntity {
  final String? id;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final bool? isAccountVerified;

  ClientDetailsEntity({required this.id, required this.username,required this.firstName,required this.lastName,required this.gender,required this.isAccountVerified,});
}