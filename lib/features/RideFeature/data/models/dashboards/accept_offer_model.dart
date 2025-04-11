import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/accept_offer_entity.dart';

class AcceptOfferModel extends AcceptOfferEntity {
  AcceptOfferModel({
    required super.tripId,
    required super.waitingTime,
    required super.locationToArriveFromTitle,
    required super.locationToArriveToTitle,
    required super.locationToArriveStartLatitude,
    required super.locationToArriveStartLongitude,
    required super.locationToArriveTargetLatitude,
    required super.locationToArriveTargetLongitude,
    required super.locationFromTitle,
    required super.locationToTitle,
    required super.locationStartLatitude,
    required super.locationStartLongitude,
    required super.locationTargetLatitude,
    required super.locationTargetLongitude,
    required super.clientId,
    required super.clientFirstName,
    required super.clientLastName,
    required super.profilePictureUrl,
    required super.averageRating,
    required super.totalRatings,
  });

  // Factory constructor to create an AcceptOfferModel from JSON
  factory AcceptOfferModel.fromJson(Map<String, dynamic> json) {
    final tripDetails = json['tripDetails'] ?? {};
    final locationToArrive = tripDetails['locationToArrive'] ?? {};
    final location = tripDetails['location'] ?? {};
    final clientDetails = json['clientDetails'] ?? {};
    final rating = clientDetails['rating'] ?? {};

    return AcceptOfferModel(
      tripId: tripDetails['id'] ?? '',
      waitingTime: locationToArrive['youArrivingIn']?.toString() ?? '0',
      locationToArriveFromTitle: locationToArrive['fromTitle'] ?? '',
      locationToArriveToTitle: locationToArrive['toTitle'],
      locationToArriveStartLatitude: locationToArrive['start']?['latitude'] ?? '',
      locationToArriveStartLongitude: locationToArrive['start']?['longitude'] ?? '',
      locationToArriveTargetLatitude: locationToArrive['target']?['latitude'] ?? '',
      locationToArriveTargetLongitude: locationToArrive['target']?['longitude'] ?? '',
      locationFromTitle: location['fromTitle'],
      locationToTitle: location['toTitle'],
      locationStartLatitude: location['start']?['latitude'] ?? '',
      locationStartLongitude: location['start']?['longitude'] ?? '',
      locationTargetLatitude: location['target']?['latitude'] ?? '',
      locationTargetLongitude: location['target']?['longitude'] ?? '',
      clientId: clientDetails['id'] ?? '',
      clientFirstName: clientDetails['firstName'] ?? '',
      clientLastName: clientDetails['lastName'] ?? '',
      profilePictureUrl: clientDetails['profilePictureUrl'] ?? '',
      averageRating: rating['averageRating'] ?? 0,
      totalRatings: rating['totalRatings'] ?? 0,
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'tripDetails': {
        'id': tripId,
        'locationToArrive': {
          'youArrivingIn': int.tryParse(waitingTime) ?? 0,
          'fromTitle': locationToArriveFromTitle,
          'toTitle': locationToArriveToTitle,
          'start': {
            'latitude': locationToArriveStartLatitude,
            'longitude': locationToArriveStartLongitude,
          },
          'target': {
            'latitude': locationToArriveTargetLatitude,
            'longitude': locationToArriveTargetLongitude,
          }
        },
        'location': {
          'fromTitle': locationFromTitle,
          'toTitle': locationToTitle,
          'start': {
            'latitude': locationStartLatitude,
            'longitude': locationStartLongitude,
          },
          'target': {
            'latitude': locationTargetLatitude,
            'longitude': locationTargetLongitude,
          }
        }
      },
      'clientDetails': {
        'id': clientId,
        'firstName': clientFirstName,
        'lastName': clientLastName,
        'profilePictureUrl': profilePictureUrl,
        'rating': {
          'averageRating': averageRating,
          'totalRatings': totalRatings,
        }
      }
    };
  }

  // Additional utility methods
  String getFullName() {
    return '$clientFirstName $clientLastName'.trim();
  }

  String getFormattedRating() {
    return '$averageRating (${totalRatings.toInt()} ratings)';
  }

  String getEstimatedArrivalTime() {
    final now = DateTime.now();
    final arrivalTimeMs = now.millisecondsSinceEpoch + (int.tryParse(waitingTime) ?? 0) * 1000;
    final arrivalTime = DateTime.fromMillisecondsSinceEpoch(arrivalTimeMs);

    // Format time as HH:MM
    final hour = arrivalTime.hour.toString().padLeft(2, '0');
    final minute = arrivalTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Example of coordinates conversion utility
  Map<String, double> getClientLocationCoordinates() {
    return {
      'latitude': double.tryParse(locationStartLatitude) ?? 0.0,
      'longitude': double.tryParse(locationStartLongitude) ?? 0.0,
    };
  }

  Map<String, double> getDestinationCoordinates() {
    return {
      'latitude': double.tryParse(locationTargetLatitude) ?? 0.0,
      'longitude': double.tryParse(locationTargetLongitude) ?? 0.0,
    };
  }
}