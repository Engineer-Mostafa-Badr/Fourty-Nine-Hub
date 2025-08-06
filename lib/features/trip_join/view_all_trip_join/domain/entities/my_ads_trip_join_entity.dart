class MyAdsTripJoinEntity {
  final List<MyAdsTripDocEntity>? offers;
  final PaginationEntity? pagination;

  MyAdsTripJoinEntity({
    this.offers,
    this.pagination,
  });
}

class MyAdsTripDocEntity {
  final String? id;
  final double? pricePerSeat;
  final String? status;
  final int? views;
  final bool? isRepeat;
  final int? passengers;
  final String? startDate;
  final String? offerType;
  final bool? isPremium;
  final String? phoneNumber;
  final String? createdAt;
  final IsButtonEnabledEntity? isButtonEnabled;
  final VehicleDetailsEntity? vehicleDetails;
  final LocationEntity? location;

  MyAdsTripDocEntity({
    this.id,
    this.pricePerSeat,
    this.status,
    this.views,
    this.isRepeat,
    this.passengers,
    this.startDate,
    this.offerType,
    this.isPremium,
    this.phoneNumber,
    this.createdAt,
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

class PaginationEntity {
  final int? page;
  final int? limit;
  final int? totalItems;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPrevPage;
  final int? nextPage;
  final int? prevPage;

  PaginationEntity({
    this.page,
    this.limit,
    this.totalItems,
    this.totalPages,
    this.hasNextPage,
    this.hasPrevPage,
    this.nextPage,
    this.prevPage,
  });
}
