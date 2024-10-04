class CarpoolRouteInfoModel {
  num? driverPrice;
  num? driverPriceComfort;
  num? priceForEveryUser;
  num? priceForEveryUserComfort;
  num? duration;
  num? distance;
  String? destinationAddress;
  String? originAddress;
  String? locationForFirstMidpoint;
  String? locationForSecondMidpoint;
  List<double?>? startLocation;
  List<double?>? targetLocation;
  List<double?>? firstMidpoint;
  List<double?>? secondMidpoint;
  bool? womenDriverOnly;
  bool? womenOnly;
  bool? comfort;

  CarpoolRouteInfoModel({
    this.driverPrice,
    this.driverPriceComfort,
    this.priceForEveryUser,
    this.priceForEveryUserComfort,
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

  @override
  String toString() {
    return 'CarpoolRouteInfoModel(driverPrice: $driverPrice, driverPriceComfort: $driverPriceComfort, priceForEveryUser: $priceForEveryUser, priceForEveryUserComfort: $priceForEveryUserComfort, duration: $duration, distance: $distance, destinationAddress: $destinationAddress, originAddress: $originAddress, locationForFirstMidpoint: $locationForFirstMidpoint, locationForSecondMidpoint: $locationForSecondMidpoint, startLocation: $startLocation, targetLocation: $targetLocation, firstMidpoint: $firstMidpoint, secondMidpoint: $secondMidpoint, womenDriverOnly: $womenDriverOnly, womenOnly: $womenOnly, comfort: $comfort)';
  }

  factory CarpoolRouteInfoModel.fromJson(Map<String, dynamic> json) {
    return CarpoolRouteInfoModel(
      driverPrice: json['driverPrice'] as num?,
      driverPriceComfort: json['driverPriceComfort'] as num?,
      priceForEveryUser: json['priceForEveryUser'] as num?,
      priceForEveryUserComfort: json['priceForEveryUserComfort'] as num?,
      duration: json['duration'] as num?,
      distance: json['distance'] as num?,
      destinationAddress: json['destinationAddress'] as String?,
      originAddress: json['originAddress'] as String?,
      locationForFirstMidpoint: json['locationForFirstMidpoint'] as String?,
      locationForSecondMidpoint: json['locationForSecondMidpoint'] as String?,
      startLocation: (json['startLocation'] as List<dynamic>).map<double>((e) => e.toDouble()).toList(),
      targetLocation: (json['targetLocation'] as List<dynamic>).map<double>((e) => e.toDouble()).toList(),
      firstMidpoint: (json['firstMidpoint'] as List<dynamic>).map<double>((e) => e.toDouble()).toList(),
      secondMidpoint: (json['secondMidpoint'] as List<dynamic>).map<double>((e) => e.toDouble()).toList(),
      womenDriverOnly: json['womenDriverOnly'] as bool?,
      womenOnly: json['womenOnly'] as bool?,
      comfort: json['comfort'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'driverPrice': driverPrice,
        'driverPriceComfort': driverPriceComfort,
        'priceForEveryUser': priceForEveryUser,
        'priceForEveryUserComfort': priceForEveryUserComfort,
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
