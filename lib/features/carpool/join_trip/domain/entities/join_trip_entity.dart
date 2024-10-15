class JoinTripCarPoolParam {
  bool? comfort;
  List<double>? userLocation;
  String? tripId;
  String? seatName;
  JoinTripCarPoolParam({
    this.seatName,
    this.tripId,
    this.comfort,
    this.userLocation,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'comfort': comfort,
      'seatName': seatName,
      'tripId': tripId,
      'userLocation': userLocation,
    };
  }
}
