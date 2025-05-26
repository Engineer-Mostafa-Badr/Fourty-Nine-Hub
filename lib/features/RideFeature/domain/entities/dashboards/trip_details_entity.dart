import 'location_entity.dart';

class TripDetailsEntity {
  final String id;
  final num price;
  final String status;
  final String pickupTime;
  final bool isPremium;
  final num passengers;
  final String note;
  final LocationEntity startLocation;
  final LocationEntity targetLocation;
  final String createdAt;

  TripDetailsEntity({
    required this.id,
    required this.price,
    required this.status,
    required this.pickupTime,
    required this.isPremium,
    required this.passengers,
    required this.note,
    required this.startLocation,
    required this.targetLocation,
    required this.createdAt,
  });
}
