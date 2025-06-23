class MyBookingEntity{
  final String id;
  final String creatorId;
  String? status;
  final bool isPremium;
  final num availableSeats;
  final num pricePerSeat;
  final List<dynamic> clients;
  final String startAddress;
  final String targetAddress;
  final List<dynamic> startLocation;
  final List<dynamic> targetLocation;
  final List<dynamic> waypoints;
  final String createdAt;

  MyBookingEntity({required this.id, required this.clients,required this.pricePerSeat,required this.creatorId,required this.startAddress,required this.targetAddress, this.status, required this.isPremium, required this.availableSeats, required this.startLocation, required this.targetLocation, required this.waypoints, required this.createdAt});
}