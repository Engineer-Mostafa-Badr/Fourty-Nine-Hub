import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';

class MyBookingModel extends MyBookingEntity {
  MyBookingModel(
      {required super.id, super.clients, super.pricePerSeat, super.polyLine,required super.creatorId, super.status, super.isPremium, super.availableSeats, super.startLocation, super.targetLocation, super.features , super.createdAt});

  factory MyBookingModel.fromJson(Map<String, dynamic> json) {
    return MyBookingModel(
      id: json['id'] ?? '',
      creatorId: json['creatorId'] ?? '',
      pricePerSeat: json['pricePerSeat'].ceil() ?? 0,
      clients: json['clients'] != null
          ? (json['clients'] as List)
          .map((e) => BookingClientModel.fromJson(e as Map<String, dynamic>))
          .toList()
          : [],
      polyLine: json['polyline']!=null?json['polyline']['coordinates'] ?? []:[],
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
  BookingClientModel({required super.id, required super.location});

  factory BookingClientModel.fromJson(Map<String, dynamic> json) {
    return BookingClientModel(
      id: json['id'] ?? '',
      location: MyBookingLocationModel.fromJson(json['pickupLocation'])
    );
  }
}
