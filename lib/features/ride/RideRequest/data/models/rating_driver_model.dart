class RattingDriverModel {
  final List rate;
  final String comment;
  final String driverId;
  final String tripId;

  RattingDriverModel(
      {required this.rate,
      required this.comment,
      required this.driverId,
      required this.tripId});

  Map<String, dynamic> toJson() {
    return {
      "rate": rate,
      "comment": comment,
      "driverId": driverId,
      "tripId": tripId
    };
  }
}
