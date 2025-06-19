// my_ads_trip_join_entity.dart

class MyAdsTripJoinEntity {
  final bool? subscribedPremium;
  final String? subscriptionEndDate;
  final List<MyAdsTripDocEntity>? trips;
  final PaginationEntity? pagination;

  MyAdsTripJoinEntity({
    this.subscribedPremium,
    this.subscriptionEndDate,
    this.trips,
    this.pagination,
  });
}

class MyAdsTripDocEntity {
  final String? id;
  final VehicleEntity? vehicle;
  final String? fromAr;
  final String? toAr;
  final String? fromEn;
  final String? toEn;
  final int? passengers;
  final int? price;
  final int? time;
  final String? countryCode;
  final bool? isRepeat;
  final String? status;
  final String? createdAt;
  final int? views;

  MyAdsTripDocEntity({
    this.id,
    this.vehicle,
    this.fromAr,
    this.toAr,
    this.fromEn,
    this.toEn,
    this.passengers,
    this.price,
    this.time,
    this.countryCode,
    this.isRepeat,
    this.status,
    this.createdAt,
    this.views,
  });
}

class VehicleEntity {
  final String? id;
  final String? brand;
  final String? model;

  VehicleEntity({
    this.id,
    this.brand,
    this.model,
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
