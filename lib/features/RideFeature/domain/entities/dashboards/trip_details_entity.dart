import 'location_entity.dart';

class TripDetailsEntity {
  final String id;
  final double price;
  final String status;
  final int distance;
  final int duration;
  final bool isPremium;
  final bool autoAccept;
  final int passengers;
  final bool freeTripForDriver;
  final String paymentMethod;
  final LocationEntity startLocation;
  final LocationEntity targetLocation;

  TripDetailsEntity({
    required this.id,
    required this.price,
    required this.status,
    required this.distance,
    required this.duration,
    required this.isPremium,
    required this.autoAccept,
    required this.passengers,
    required this.freeTripForDriver,
    required this.paymentMethod,
    required this.startLocation,
    required this.targetLocation,
  });
}
