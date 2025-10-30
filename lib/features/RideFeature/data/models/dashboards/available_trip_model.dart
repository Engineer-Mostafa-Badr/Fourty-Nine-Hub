import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_trip_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AvailableTripModel extends AvailableTripEntity {
  AvailableTripModel({
    super.id,
    super.autoAcceptEnabled,
    super.isAutoAccept,
    super.isPremium,
    super.platformFee,
    super.isComfort,
    super.isNonSmoking,
    super.price,
    super.lastOffer,
    super.paymentMethod,
    super.description,
    super.createdAt,
    super.subcategory,
    super.route,
    super.state,
    super.offerPriceRange,
    super.clientDetails,
  });

  factory AvailableTripModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AvailableTripModel();

    return AvailableTripModel(
      id: json['id'] as String?,
      autoAcceptEnabled: json['autoAcceptEnabled'] as bool?,
      isAutoAccept: json['isAutoAccept'] as bool?,
      isPremium: json['isPremium'] as bool?,
      isComfort: json['isComfort'] as bool?,
      platformFee: json['platformFee'] as num?,
      isNonSmoking: json['isNonSmoking'] as bool?,
      price: (json['price'] as num?)?.toDouble(),
      lastOffer: (json['price'] as num?),
      paymentMethod: json['paymentMethod'] as String?,
      description: json['description'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      subcategory: AvailableTripSubcategoryModel.fromJson(json['subcategory']),
      route: AvailableTripRouteModel.fromJson(json['route']),
      state: AvailableTripStateModel.fromJson(json['state']),
      offerPriceRange: OfferPriceRangeModel.fromJson(json['offerPriceRange']),
      clientDetails: ClientDetailsModel.fromJson(json['clientDetails']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'autoAcceptEnabled': autoAcceptEnabled,
    'isAutoAccept': isAutoAccept,
    'isPremium': isPremium,
    'isComfort': isComfort,
    'isNonSmoking': isNonSmoking,
    'price': price,
    'paymentMethod': paymentMethod,
    'description': description,
    'createdAt': createdAt?.toIso8601String(),
    'subcategory':
    (subcategory as AvailableTripSubcategoryModel?)?.toJson(),
    'route': (route as AvailableTripRouteModel?)?.toJson(),
    'state': (state as AvailableTripStateModel?)?.toJson(),
    'offerPriceRange': (state as OfferPriceRangeModel?)?.toJson(),
  };
}

class AvailableTripSubcategoryModel extends AvailableTripSubcategoryEntity {
  AvailableTripSubcategoryModel({
    super.id,
    super.nameAr,
    super.nameEn,
    super.imageUrl,
  });

  factory AvailableTripSubcategoryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AvailableTripSubcategoryModel();

    return AvailableTripSubcategoryModel(
      id: json['id'] as String?,
      nameAr: json['nameAr'] as String?,
      nameEn: json['nameEn'] as String?,
      imageUrl: json['picture'] as String?, // ✅ correct key name
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nameAr': nameAr,
    'nameEn': nameEn,
    'picture': imageUrl,
  };
}

class AvailableTripRouteModel extends AvailableTripRouteEntity {
  AvailableTripRouteModel({
    super.pickupToDropPolyline,
    super.driverPosition,
    super.pickupPoint,
    super.dropPoint,
  });

  factory AvailableTripRouteModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AvailableTripRouteModel();

    List<LatLng>? polyline = (json['pickupToDropPolyline'] as List?)
        ?.map((coords) => LatLng(
      (coords[0] as num).toDouble(),
      (coords[1] as num).toDouble(),
    ))
        .toList();

    return AvailableTripRouteModel(
      pickupToDropPolyline: polyline,
      driverPosition: DriverPositionModel.fromJson(json['driverPosition']),
      pickupPoint: TripPointModel.fromJson(json['pickupPoint']),
      dropPoint: TripPointModel.fromJson(json['dropPoint']),
    );
  }

  Map<String, dynamic> toJson() => {
    'pickupToDropPolyline':
    pickupToDropPolyline?.map((e) => [e.latitude, e.longitude]).toList(),
    'driverPosition': (driverPosition as DriverPositionModel?)?.toJson(),
    'pickupPoint': (pickupPoint as TripPointModel?)?.toJson(),
    'dropPoint': (dropPoint as TripPointModel?)?.toJson(),
  };
}


class DriverPositionModel extends DriverPositionEntity {
  DriverPositionModel({
    super.longitude,
    super.latitude,
    super.distanceToPickup,
    super.durationToPickup,
  });

  factory DriverPositionModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return DriverPositionModel();

    return DriverPositionModel(
      longitude: (json['longitude'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      distanceToPickup: (json['distanceToPickup'] as num?)?.toDouble(),
      durationToPickup: (json['durationToPickup'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'longitude': longitude,
    'latitude': latitude,
    'distanceToPickup': distanceToPickup,
    'durationToPickup': durationToPickup,
  };
}



class TripPointModel extends TripPointEntity {
  TripPointModel({
    super.address,
    super.longitude,
    super.latitude,
    super.distanceFromPickup,
    super.durationFromPickup,
  });

  factory TripPointModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TripPointModel();

    return TripPointModel(
      address: json['address'] as String?,
      longitude: (json['longitude'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      distanceFromPickup: (json['distanceFromPickup'] as num?)?.toDouble(),
      durationFromPickup: (json['durationFromPickup'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'address': address,
    'longitude': longitude,
    'latitude': latitude,
    'distanceFromPickup': distanceFromPickup,
    'durationFromPickup': durationFromPickup,
  };
}


class AvailableTripStateModel extends AvailableTripStateEntity {
  AvailableTripStateModel({super.isButtonEnabled});

  factory AvailableTripStateModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AvailableTripStateModel();

    return AvailableTripStateModel(
      isButtonEnabled: json['isButtonEnabled'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'isButtonEnabled': isButtonEnabled,
  };
}

class OfferPriceRangeModel extends OfferPriceRangeEntity {
  OfferPriceRangeModel({super.lowestFare,super.highestFare});

  factory OfferPriceRangeModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return OfferPriceRangeModel();

    return OfferPriceRangeModel(
      lowestFare: json['lowestFare'] as num?,
      highestFare: json['highestFare'] as num?,
    );
  }

  Map<String, dynamic> toJson() => {
    'lowestFare': lowestFare,
    'highestFare': highestFare,
  };
}

class ClientDetailsModel extends ClientDetailsEntity {
  ClientDetailsModel({super.id,super.username,super.firstName,super.lastName,super.gender,super.isAccountVerified,});

  factory ClientDetailsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ClientDetailsModel();

    return ClientDetailsModel(
      id: json['id'] as String?,
      username: json['username'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      gender: json['gender'] as String?,
      isAccountVerified: json['isAccountVerified'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'firstName': firstName,
    'lastName': lastName,
    'gender': gender,
    'isAccountVerified': isAccountVerified,
  };
}