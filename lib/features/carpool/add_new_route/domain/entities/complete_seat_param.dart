class CompleteSeatParam {
  final String userSeat;
  final String tripId;

  CompleteSeatParam({
    required this.userSeat,
    required this.tripId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userSeat': userSeat,
      'tripId': tripId,
    };
  }
}
