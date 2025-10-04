import '../../../domain/entities/available_trip_join_entity.dart';

class AvailableTripJoinModel extends AvailableTripJoinEntity {
  AvailableTripJoinModel({
    super.id,
    super.creatorId,
    super.pricePerSeat,
    super.isNormalRequested,
    super.isPremiumRequested,
    super.status,
    super.viewerIds,
    super.isRepeat,
    super.isView,
    super.passengers,
    super.startDate,
    super.offerType,
    super.isPremium,
    super.lastViewers,
    super.phoneNumber, // ✅ Added
    IsButtonEnabledModel? super.isButtonEnabled,
    VehicleDetailsModel? super.vehicleDetails,
    LocationModel? super.location,
  });

  factory AvailableTripJoinModel.fromJson(Map<String, dynamic> json) {
    return AvailableTripJoinModel(
      id: json['id'] as String?,
      creatorId: json['creatorId'] as String?,
      pricePerSeat: (json['pricePerSeat'] as num?)?.toDouble(),
      status: json['status'] as String?,
      viewerIds: (json['viewerIds'] as num?)?.toInt(),
      isRepeat: json['isRepeat'] as bool?,
      isView: json['isView'] as bool?,
      isNormalRequested: json['isNormalRequested'] as bool?,
      isPremiumRequested: json['isPremiumRequested'] as bool?,
      passengers: (json['passengers'] as num?)?.toInt(),
      startDate: json['startDate'] as String?,
      offerType: json['offerType'] as String?,
      isPremium: json['isPremium'] as bool?,
      phoneNumber: json['phoneNumber'] as String?, // ✅ Added
      lastViewers:  (json['lastViewers'] as List<dynamic>?)
          ?.map((e) => ViewerModel.fromJson(e))
          .toList(),
      isButtonEnabled: json['isButtonEnabled'] != null
          ? IsButtonEnabledModel.fromJson(json['isButtonEnabled'])
          : null,
      vehicleDetails: json['vehicleDetails'] != null
          ? VehicleDetailsModel.fromJson(json['vehicleDetails'])
          : null,
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
    );
  }
}

class IsButtonEnabledModel extends IsButtonEnabledEntity {
  IsButtonEnabledModel({super.state});

  factory IsButtonEnabledModel.fromJson(Map<String, dynamic> json) {
    return IsButtonEnabledModel(
      state: json['state'] as bool?,
    );
  }
}

class ViewerModel extends ViewerEntity {
  ViewerModel({super.id,super.firstName,super.lastName,super.gender});

  factory ViewerModel.fromJson(Map<String, dynamic> json) {
    return ViewerModel(
      id: json['id']??'',
      firstName: json['firstName']??'',
      lastName: json['lastName']??'',
      gender: json['gender']??'',
    );
  }
}

class VehicleDetailsModel extends VehicleDetailsEntity {
  VehicleDetailsModel({
    super.brandAr,
    super.brandEn,
    super.modelAr,
    super.modelEn,
  });

  factory VehicleDetailsModel.fromJson(Map<String, dynamic> json) {
    return VehicleDetailsModel(
      brandAr: json['brandAr'] as String?,
      brandEn: json['brandEn'] as String?,
      modelAr: json['modelAr'] as String?,
      modelEn: json['modelEn'] as String?,
    );
  }
}

class LocationModel extends LocationEntity {
  LocationModel({
    CoordinatesModel? start,
    CoordinatesModel? target,
  }) : super(
    start: start,
    target: target,
  );

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      start: json['start'] != null
          ? CoordinatesModel.fromJson(json['start'])
          : null,
      target: json['target'] != null
          ? CoordinatesModel.fromJson(json['target'])
          : null,
    );
  }
}

class CoordinatesModel extends CoordinatesEntity {
  CoordinatesModel({
    super.address,
    super.coordinates,
  });

  factory CoordinatesModel.fromJson(Map<String, dynamic> json) {
    return CoordinatesModel(
      address: json['address'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}
