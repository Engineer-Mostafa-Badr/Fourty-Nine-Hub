class RideExpectedPriceParams {
  final String id;
  final List<double> startLocation;
  final List<double> targetLocation;
  final List<double>? wayPointOne;
  final List<double>? wayPointTwo;
  final bool? comfort;
  final bool? nonSmoking;
  final bool? autoAccept;
  final bool? isPremium;

  RideExpectedPriceParams({
    required this.id,
    required this.startLocation,
    required this.targetLocation,
    this.wayPointOne,
    this.wayPointTwo,
    this.comfort,
    this.nonSmoking,
    this.autoAccept,
    this.isPremium,
  });

  // toJson method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "startLocation": {
        "latitude": startLocation[0],
        "longitude": startLocation[1],
      },
      "targetLocation": {
        "latitude": targetLocation[0],
        "longitude": targetLocation[1],
      },
      if (wayPointOne != null)
        "wayPointOne": {"latitude": wayPointOne![0], "longitude": wayPointOne![1]},
      if (wayPointTwo != null)
        "wayPointTwo": {"latitude": wayPointTwo![0], "longitude": wayPointTwo![1]},
      "options": {
        "comfort": true,
        "nonSmoking": true,
        "autoAccept": true,
        if (isPremium != null) "isPremium": isPremium,
      },
    };
    if ((data["options"] as Map).isEmpty) {
      data.remove("options");
    }
    return data;
  }
}
