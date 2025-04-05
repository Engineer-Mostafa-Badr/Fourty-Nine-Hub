

import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_offer_entity.dart';

class RideOfferModel extends RideOfferEntity {
  RideOfferModel({
    required super.offerId,
    required super.driverId,
    required super.tripId,
    required super.driverName,
    required super.driverImage,
    required super.price,
    required super.carModel,
    required super.distance,
    required super.duration,
    required super.rating,
    required super.ratingCount,
    required super.tripsCount,
  });

  factory RideOfferModel.fromJson(Map<String, dynamic> json) {
    final driverDetails = json['driverDetails'] ?? {};
    final tripDetails = json['tripDetails'] ?? {};
    final vehicleDetails = driverDetails['vehicleDetails'] ?? {};
    final ratingDetails = driverDetails['rating'] ?? {};

    return RideOfferModel(
      offerId: json['id'] ?? '',
      driverId: driverDetails['id'] ?? '',
      tripId: tripDetails['id'] ?? '',
      driverName: driverDetails['firstName'],
      driverImage: driverDetails['picture'],
      price: (tripDetails['priceOffer'] as num?)?.toInt(),
      carModel: vehicleDetails['carModel'],
      distance: (tripDetails['distance'] as num?)?.toDouble(),
      duration: (tripDetails['arrivalTimeToClient'] as num?)?.toDouble(),
      rating: (ratingDetails['averageRating'] as num?)?.toDouble(),
      ratingCount: (ratingDetails['countRating'] as int?),
      tripsCount: (driverDetails['tripsCount'] as int?),
    );
  }
}
