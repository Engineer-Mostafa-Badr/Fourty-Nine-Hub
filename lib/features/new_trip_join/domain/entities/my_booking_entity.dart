class MyBookingEntity{
  final String id;
  final String creatorId;
  String? status;
  bool? isPremium;
  List<dynamic>? features;
  num? availableSeats;
  num? pricePerSeat;
  List<dynamic>? polyLine;
  List<BookingClientEntity>? clients;
  MyBookingLocationEntity? startLocation;
  MyBookingLocationEntity? targetLocation;
  String? createdAt;

  MyBookingEntity( {required this.id, this.clients ,this.features ,this.pricePerSeat, this.polyLine ,required this.creatorId, this.status, this.isPremium, this.availableSeats, this.startLocation, this.targetLocation, this.createdAt});
}

class MyBookingLocationEntity{
  final String address;
  final List<dynamic> location;

  MyBookingLocationEntity({required this.address, required this.location});
}

class BookingClientEntity{
  final String id;
  String? status;
  String? driverArrivalTime;
  num? pickupDistanceFromStart;
  String? driverWaitingTime;
  final MyBookingLocationEntity location;

  BookingClientEntity( {required this.id, required this.location, this.status,this.pickupDistanceFromStart, this.driverArrivalTime, this.driverWaitingTime,});
}