import '../../../domain/entities/my_ads_trip_join_entity.dart';

class MyAdsTripJoinModel extends MyAdsTripJoinEntity {
  MyAdsTripJoinModel({
    super.offers,
    super.pagination,
  });

  factory MyAdsTripJoinModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return MyAdsTripJoinModel(
      offers: (data['offers'] as List<dynamic>?)
          ?.map((e) => MyAdsTripDocModel.fromJson(e))
          .toList(),
      pagination: data['pagination'] != null
          ? PaginationModel.fromJson(data['pagination'])
          : null,
    );
  }
}

class MyAdsTripDocModel extends MyAdsTripDocEntity {
  MyAdsTripDocModel({
    super.id,
    super.pricePerSeat,
    super.status,
    super.views,
    super.isRepeat,
    super.passengers,
    super.startDate,
    super.offerType,
    super.isPremium,
    super.isButtonEnabled,
    super.vehicleDetails,
    super.location,
  });

  factory MyAdsTripDocModel.fromJson(Map<String, dynamic> json) {
    return MyAdsTripDocModel(
      id: json['id'],
      pricePerSeat: (json['pricePerSeat'] as num?)?.toDouble(),
      status: json['status'],
      views: json['views'],
      isRepeat: json['isRepeat'],
      passengers: json['passengers'],
      startDate: json['startDate'],
      offerType: json['offerType'],
      isPremium: json['isPremium'],
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
      state: json['state'],
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
      brandAr: json['brandAr'],
      brandEn: json['brandEn'],
      modelAr: json['modelAr'],
      modelEn: json['modelEn'],
    );
  }
}

class LocationModel extends LocationEntity {
  LocationModel({
    super.start,
    super.target,
  });

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
      address: json['address'],
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}

class PaginationModel extends PaginationEntity {
  PaginationModel({
    super.page,
    super.limit,
    super.totalItems,
    super.totalPages,
    super.hasNextPage,
    super.hasPrevPage,
    super.nextPage,
    super.prevPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'],
      limit: json['limit'],
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      hasNextPage: json['hasNextPage'],
      hasPrevPage: json['hasPrevPage'],
      nextPage: json['nextPage'],
      prevPage: json['prevPage'],
    );
  }
}
