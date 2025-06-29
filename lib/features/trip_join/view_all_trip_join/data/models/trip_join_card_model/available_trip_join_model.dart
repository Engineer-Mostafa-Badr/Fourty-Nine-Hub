import '../../../domain/entities/available_trip_join_entity.dart';

class AvailableTripJoinModel extends AvailableTripJoinEntity {
  AvailableTripJoinModel({
    String? id,
    double? pricePerSeat,
    String? status,
    num? viewerIds,
    bool? isRepeat,
    int? passengers,
    String? startDate,
    String? offerType,
    bool? isPremium,
    IsButtonEnabledModel? isButtonEnabled,
    VehicleDetailsModel? vehicleDetails,
    LocationModel? location,
  }) : super(
    id: id,
    pricePerSeat: pricePerSeat,
    status: status,
    viewerIds: viewerIds,
    isRepeat: isRepeat,
    passengers: passengers,
    startDate: startDate,
    offerType: offerType,
    isPremium: isPremium,
    isButtonEnabled: isButtonEnabled,
    vehicleDetails: vehicleDetails,
    location: location,
  );

  factory AvailableTripJoinModel.fromJson(Map<String, dynamic> json) {
    return AvailableTripJoinModel(
      id: json['id'] as String?,
      pricePerSeat: (json['pricePerSeat'] as num?)?.toDouble(),
      status: json['status'] as String?,
      viewerIds: (json['viewerIds'] as num?)?.toInt(),
      isRepeat: json['isRepeat'] as bool?,
      passengers: (json['passengers'] as num?)?.toInt(),
      startDate: json['startDate'] as String?,
      offerType: json['offerType'] as String?,
      isPremium: json['isPremium'] as bool?,
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
  IsButtonEnabledModel({bool? state}) : super(state: state);

  factory IsButtonEnabledModel.fromJson(Map<String, dynamic> json) {
    return IsButtonEnabledModel(
      state: json['state'] as bool?,
    );
  }
}

class VehicleDetailsModel extends VehicleDetailsEntity {
  VehicleDetailsModel({
    String? brandAr,
    String? brandEn,
    String? modelAr,
    String? modelEn,
  }) : super(
    brandAr: brandAr,
    brandEn: brandEn,
    modelAr: modelAr,
    modelEn: modelEn,
  );

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
    String? address,
    List<double>? coordinates,
  }) : super(
    address: address,
    coordinates: coordinates,
  );

  factory CoordinatesModel.fromJson(Map<String, dynamic> json) {
    return CoordinatesModel(
      address: json['address'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}
