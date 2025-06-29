class AvailableTripJoinEntity {
  final String? id;
  final double? pricePerSeat;
  final String? status;
  final num? viewerIds;
  final bool? isRepeat;
  final int? passengers;
  final String? startDate;
  final String? offerType;
  final bool? isPremium;
  final IsButtonEnabledEntity? isButtonEnabled;
  final VehicleDetailsEntity? vehicleDetails;
  final LocationEntity? location;

  AvailableTripJoinEntity({
    this.id,
    this.pricePerSeat,
    this.status,
    this.viewerIds,
    this.isRepeat,
    this.passengers,
    this.startDate,
    this.offerType,
    this.isPremium,
    this.isButtonEnabled,
    this.vehicleDetails,
    this.location,
  });
}

class IsButtonEnabledEntity {
  final bool? state;

  IsButtonEnabledEntity({this.state});
}

class VehicleDetailsEntity {
  final String? brandAr;
  final String? brandEn;
  final String? modelAr;
  final String? modelEn;

  VehicleDetailsEntity({
    this.brandAr,
    this.brandEn,
    this.modelAr,
    this.modelEn,
  });
}

class LocationEntity {
  final CoordinatesEntity? start;
  final CoordinatesEntity? target;

  LocationEntity({
    this.start,
    this.target,
  });
}

class CoordinatesEntity {
  final String? address;
  final List<double>? coordinates;

  CoordinatesEntity({
    this.address,
    this.coordinates,
  });
}
