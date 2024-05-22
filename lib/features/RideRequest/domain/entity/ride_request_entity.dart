class RideRequestEntity {
  final int id;
  final String fromAddress;
  final String toAddress;
  final int? userId;
  final int? driverId;
  final double fromLat;
  final double fromLng;
  final double toLat;
  final double toLng;
  final bool autoAccept;
  final List<String> carTypes;
  final bool isAirConditioned;
  RideRequestEntity(
      {
        required this.id, 
        required this.fromAddress,
      required this.toAddress,
      this.userId,
      this.driverId,
      required this.fromLat,
      required this.fromLng,
      required this.toLat,
      required this.toLng,
      required this.autoAccept,
      required this.carTypes,
      required this.isAirConditioned});
}
