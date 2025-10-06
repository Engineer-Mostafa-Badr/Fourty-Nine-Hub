class AvailableTripJoinEntity {
  final String? id;
  final String? creatorId;
  final double? pricePerSeat;
  final String? status;
  num? viewerIds;
  final bool? isRepeat;
  bool? isView;
  bool? isNormalRequested;
  bool? isPremiumRequested;
  final int? passengers;
  final String? startDate;
  final String? offerType;
  final bool? isPremium;
  final String? phoneNumber; // ✅ Added
  final List<ViewerEntity>? lastViewers; // ✅ Added
  final IsButtonEnabledEntity? isButtonEnabled;
  final VehicleDetailsEntity? vehicleDetails;
  final LocationEntity? location;

  AvailableTripJoinEntity({
    this.id,
    this.creatorId,
    this.pricePerSeat,
    this.isNormalRequested,
    this.isPremiumRequested,
    this.status,
    this.viewerIds,
    this.isRepeat,
    this.isView,
    this.lastViewers,
    this.passengers,
    this.startDate,
    this.offerType,
    this.isPremium,
    this.phoneNumber,
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

class ViewerEntity{
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? gender;
  ViewerEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.gender,
  });
}
