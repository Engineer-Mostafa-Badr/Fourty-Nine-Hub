import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';

class MyBookingModel extends MyBookingEntity {
  MyBookingModel(
      {required super.id, super.clients,super.startTime,super.expectedArrivalDuration,super.acceptedAt, super.pricePerSeat, super.polyLine,required super.creatorId, super.status, super.isPremium, super.availableSeats, super.startLocation, super.targetLocation, super.features , super.createdAt});

  factory MyBookingModel.fromJson(Map<String, dynamic> json) {
    List<List<double>> parsedPolyline = [];

    if (json['polyline'] != null && json['polyline']['coordinates'] != null) {
      if (json['polyline']['coordinates'] is String) {
        // Decode the encoded polyline string
        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> decoded = polylinePoints.decodePolyline(
          json['polyline']['coordinates'] as String,
        );
        parsedPolyline = decoded.map((e) => [e.latitude, e.longitude]).toList();
      } else if (json['polyline']['coordinates'] is List) {
        // Use the list directly
        parsedPolyline = (json['polyline']['coordinates'] as List)
            .map((e) => (e as List).map((p) => (p as num).toDouble()).toList())
            .toList();
      }
    }

    return MyBookingModel(
      id: json['id'] ?? '',
      creatorId: json['creatorId'] ?? '',
      startTime: json['startTime'] ?? '',
      expectedArrivalDuration: json['expectedArrivalDuration'] ?? 0,
      acceptedAt: json['acceptedAt'] ?? '',
      pricePerSeat: (json['pricePerSeat'] is num) ? (json['pricePerSeat'] as num).ceil() : 0,
      clients: json['clients'] != null
          ? (json['clients'] as List)
          .map((e) => BookingClientModel.fromJson(e as Map<String, dynamic>))
          .toList()
          : [],
      polyLine: parsedPolyline,
      status: json['status'] ?? '',
      isPremium: json['isPremium'] ?? false,
      features: json['features'] ?? [],
      availableSeats: json['availableSeats'] ?? 0,
      startLocation: json['location']!=null?MyBookingLocationModel.fromJson(json['location']['start']):null,
      targetLocation: json['location']!=null?MyBookingLocationModel.fromJson(json['location']['target']):null,
      createdAt: json['createdAt'] ?? '',
    );
  }
}


class MyBookingLocationModel extends MyBookingLocationEntity{
  MyBookingLocationModel({required super.address, required super.location,});

  factory MyBookingLocationModel.fromJson(Map<String, dynamic> json) {
    return MyBookingLocationModel(
      address: json['address'] ?? '',
      location: json['coordinates'] ?? [],
);
  }
}

class BookingClientModel extends BookingClientEntity{
  BookingClientModel( {required super.id,required super.pickupTime,required super.expectedArrivalDuration, required super.location,super.polyLine,super.phoneNumber,super.pickedAddress, super.driverArrivalTime,super.pickupDistanceFromStart, super.driverWaitingTime,required super.status});

  factory BookingClientModel.fromJson(Map<String, dynamic> json) {
    List<List<double>> parsedPolyline = [];

    if (json['pickupLocation'] != null && json['pickupLocation']['polyline'] != null) {
      if (json['pickupLocation']['polyline'] is String) {
        // Decode the encoded polyline string
        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> decoded = polylinePoints.decodePolyline(
          json['pickupLocation']['polyline'] as String,
        );
        parsedPolyline = decoded.map((e) => [e.latitude, e.longitude]).toList();
      } else if (json['pickupLocation']['polyline'] is List) {
        // Use the list directly
        parsedPolyline = (json['pickupLocation']['polyline'] as List)
            .map((e) => (e as List).map((p) => (p as num).toDouble()).toList())
            .toList();
      }
    }

    return BookingClientModel(
      id: json['id'] ?? '',
        status: json['status'] ?? '',
        pickupTime: json['pickupTime'] ?? '',
        expectedArrivalDuration: json['expectedArrivalDuration'] ?? 0,
        // phoneNumber: json['phoneNumber'] ?? '',
        // pickedAddress: json['pickupLocation']!=null?json['pickupLocation']['address'] ?? '':'',
        polyLine: parsedPolyline,
        pickupDistanceFromStart: json['pickupDistanceFromStart'] ?? 0,
        driverArrivalTime: json['driverArrivalTime'],
        driverWaitingTime: json['driverWaitingTime'],
      location: MyBookingLocationModel.fromJson(json['pickupLocation'])
    );
  }
}
