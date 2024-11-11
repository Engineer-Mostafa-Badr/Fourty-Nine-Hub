class CarpoolRouteInfoModel {
  num? priceForEveryUser;
  num? driverPriceComfort;
  num? priceDriverWomen;
  num? priceForWomenOnly;
  num? duration;
  num? distance;
  String? destinationAddress;
  String? originAddress;
  String? locationForFirstMidpoint;
  String? locationForSecondMidpoint;
  List<double>? startLocation;
  List<double>? targetLocation;
  Map<String, double?>?
      firstMidpoint; // Changed to Map<String, double?> to allow nullable values
  Map<String, double?>?
      secondMidpoint; // Changed to Map<String, double?> to allow nullable values
  bool? womenDriverOnly;
  bool? womenOnly;
  bool? comfort;
  String? polyline;

  CarpoolRouteInfoModel({
    this.priceForEveryUser,
    this.driverPriceComfort,
    this.priceDriverWomen,
    this.priceForWomenOnly,
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
    this.polyline,
  });

  @override
  String toString() {
    return 'CarpoolRouteInfoModel(priceForEveryUser: $priceForEveryUser, driverPriceComfort: $driverPriceComfort, priceDriverWomen: $priceDriverWomen, priceForWomenOnly: $priceForWomenOnly, duration: $duration, distance: $distance, destinationAddress: $destinationAddress, originAddress: $originAddress, locationForFirstMidpoint: $locationForFirstMidpoint, locationForSecondMidpoint: $locationForSecondMidpoint, startLocation: $startLocation, targetLocation: $targetLocation, firstMidpoint: $firstMidpoint, secondMidpoint: $secondMidpoint, womenDriverOnly: $womenDriverOnly, womenOnly: $womenOnly, comfort: $comfort, polyline: $polyline)';
  }

  factory CarpoolRouteInfoModel.fromJson(Map<String, dynamic> json) {
    return CarpoolRouteInfoModel(
      priceForEveryUser: json['priceForEveryUser'] as num?,
      driverPriceComfort: json['PriceComfort'] as num?,
      priceDriverWomen: json['priceDriverWomen'] as num?,
      priceForWomenOnly: json['PriceWomenOnly'] as num?,
      duration: json['duration'] as num?,
      distance: json['distance'] as num?,
      destinationAddress: json['destinationAddress'] as String?,
      originAddress: json['originAddress'] as String?,
      locationForFirstMidpoint: json['locationForFirstMidpoint'] as String?,
      locationForSecondMidpoint: json['locationForSecondMidpoint'] as String?,
      startLocation: (json['startLocation'] as List<dynamic>)
          .map<double>((e) => e.toDouble())
          .toList(),
      targetLocation: (json['targetLocation'] as List<dynamic>)
          .map<double>((e) => e.toDouble())
          .toList(),
      firstMidpoint: {
        'lat': (json['firstMidpoint']['lat'] as num?)?.toDouble(),
        'lng': (json['firstMidpoint']['lng'] as num?)?.toDouble(),
      },
      secondMidpoint: {
        'lat': (json['secondMidpoint']['lat'] as num?)?.toDouble(),
        'lng': (json['secondMidpoint']['lng'] as num?)?.toDouble(),
      },
      womenDriverOnly: json['womenDriverOnly'] as bool?,
      womenOnly: json['womenOnly'] as bool?,
      comfort: json['comfort'] as bool?,
      polyline: json['polyline'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'priceForEveryUser': priceForEveryUser,
        'PriceComfort': driverPriceComfort,
        'priceDriverWomen': priceDriverWomen,
        'PriceWomenOnly': priceForWomenOnly,
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
        'polyline': polyline,
      };
}
