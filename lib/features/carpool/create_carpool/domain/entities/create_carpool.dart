class CreateCarpoolParam {
  int? priceForEveryUser;
  int? duration;
  int? distance;
  String? destinationAddress;
  String? originAddress;
  String? locationForFirstMidpoint;
  String? locationForSecondMidpoint;
  List<double>? startLocation;
  List<double>? targetLocation;
  List<double>? firstMidpoint;
  List<double>? secondMidpoint;
  bool? womenDriverOnly;
  bool? womenOnly;
  bool? comfort;

  CreateCarpoolParam({
    this.priceForEveryUser,
    this.duration,
    this.distance,
    this.destinationAddress,
    this.originAddress,
    this.locationForFirstMidpoint,
    this.locationForSecondMidpoint,
    this.startLocation,
    this.targetLocation,
    this.firstMidpoint,
    this.secondMidpoint,
    this.womenDriverOnly,
    this.womenOnly,
    this.comfort,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'priceForEveryUser': priceForEveryUser,
      'duration': duration,
      'distance': distance,
      'destinationAddress': destinationAddress,
      'originAddress': originAddress,
      'locationForFirstMidpoint': locationForFirstMidpoint,
      'locationForSecondMidpoint': locationForSecondMidpoint,
      'startLocation': startLocation,
      'targetLocation': targetLocation,
      'firstMidpoint': firstMidpoint,
      'secondMidpoint': secondMidpoint,
      'womenDriverOnly': womenDriverOnly,
      'womenOnly': womenOnly,
      'comfort': comfort,
    };
  }
}
