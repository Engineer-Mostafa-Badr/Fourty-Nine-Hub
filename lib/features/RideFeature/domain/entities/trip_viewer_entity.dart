class TripViewerEntity {
  final String driverUserId;
  final String driverImage;
  final String tripId;

  TripViewerEntity({
    required this.driverUserId,
    required this.driverImage,
    required this.tripId,
  });

  // fromJson
  factory TripViewerEntity.fromJson(Map<String, dynamic> json) {
    return TripViewerEntity(
      driverUserId: json['driverUserId'] ?? '',
      driverImage: json['driverImage'] ?? '',
      tripId: json['tripId'] ?? '',
    );
  }
}
