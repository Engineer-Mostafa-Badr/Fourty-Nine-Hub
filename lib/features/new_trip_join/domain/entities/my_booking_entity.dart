class MyBookingEntity{
  final String id;
  final String creatorId;
  String? status;
  final bool isPremium;
  final bool isComfort;
  final num availableSeats;
  final num pricePerSeat;
  final List<dynamic> clients;
  final MyBookingLocationEntity? startLocation;
  final MyBookingLocationEntity? targetLocation;
  final List<dynamic> waypoints;
  final String createdAt;

  MyBookingEntity({required this.id, required this.clients,required this.pricePerSeat,required this.creatorId, this.status, required this.isPremium, required this.isComfort, required this.availableSeats, this.startLocation, this.targetLocation, required this.waypoints, required this.createdAt});
}

class MyBookingLocationEntity{
  final String address;
  final List<dynamic> location;

  MyBookingLocationEntity({required this.address, required this.location});
}