import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';

class MyBookingModel extends MyBookingEntity {
  MyBookingModel(
      {required super.id, required super.clients,required super.pricePerSeat,required super.creatorId, super.status, required super.isPremium, required super.isComfort, required super.availableSeats, required super.startLocation, required super.targetLocation, required super.waypoints, required super.createdAt});

  factory MyBookingModel.fromJson(Map<String, dynamic> json) {
    return MyBookingModel(
      id: json['id'] ?? '',
      creatorId: json['creatorId'] ?? '',
      pricePerSeat: json['pricePerSeat'] ?? 0,
      clients: json['clients'] ?? [],
      status: json['status'] ?? '',
      isPremium: json['isPremium'] ?? false,
      isComfort: json['isComfort'] ?? false,
      availableSeats: json['availableSeats'] ?? 0,
      startLocation: json['location']!=null?MyBookingLocationModel.fromJson(json['location']['start']):null,
      targetLocation: json['location']!=null?MyBookingLocationModel.fromJson(json['location']['target']):null,
      waypoints: json['location']!=null?json['location']['waypoints']??[]:[],
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