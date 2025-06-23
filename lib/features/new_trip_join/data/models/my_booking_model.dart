import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';

class MyBookingModel extends MyBookingEntity {
  MyBookingModel(
      {required super.id, required super.clients,required super.pricePerSeat,required super.creatorId,required super.startAddress,required super.targetAddress, super.status, required super.isPremium, required super.availableSeats, required super.startLocation, required super.targetLocation, required super.waypoints, required super.createdAt});

  factory MyBookingModel.fromJson(Map<String, dynamic> json) {
    return MyBookingModel(
      id: json['id'] ?? '',
      creatorId: json['creatorId'] ?? '',
      pricePerSeat: json['pricePerSeat'] ?? 0,
      clients: json['clients'] ?? [],
      status: json['status'] ?? '',
      isPremium: json['isPremium'] ?? false,
      availableSeats: json['availableSeats'] ?? 0,
      startLocation: json['location']!=null?json['location']['start']['coordinates']??[]:[],
      startAddress: json['location']!=null?json['location']['start']['address']??'':'',
      targetAddress: json['location']!=null?json['location']['target']['address']??'':'',
      targetLocation: json['location']!=null?json['location']['target']['coordinates']??[]:[],
      waypoints: json['location']!=null?json['location']['waypoints']??[]:[],
      createdAt: json['createdAt'] ?? '',
    );
  }
}