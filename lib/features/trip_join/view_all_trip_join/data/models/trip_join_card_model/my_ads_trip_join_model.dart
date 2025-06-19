import '../../../domain/entities/my_ads_trip_join_entity.dart';

class MyAdsTripJoinModel extends MyAdsTripJoinEntity {
  MyAdsTripJoinModel({
    super.subscribedPremium,
    super.subscriptionEndDate,
    super.trips,
    super.pagination,
  });

  factory MyAdsTripJoinModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return MyAdsTripJoinModel(
      subscribedPremium: data['subscribedPremium'],
      subscriptionEndDate: data['subscriptionEndDate'],
      trips: data['trips'] != null
          ? List<MyAdsTripDocModel>.from(
          data['trips'].map((x) => MyAdsTripDocModel.fromJson(x)))
          : null,
      pagination: data['pagination'] != null
          ? PaginationModel.fromJson(data['pagination'])
          : null,
    );
  }
}

class MyAdsTripDocModel extends MyAdsTripDocEntity {
  MyAdsTripDocModel({
    super.id,
    super.vehicle,
    super.fromAr,
    super.toAr,
    super.fromEn,
    super.toEn,
    super.passengers,
    super.price,
    super.time,
    super.countryCode,
    super.isRepeat,
    super.status,
    super.createdAt,
    super.views,
  });

  factory MyAdsTripDocModel.fromJson(Map<String, dynamic> json) {
    return MyAdsTripDocModel(
      id: json['_id'],
      vehicle: json['vehicleId'] != null
          ? VehicleModel.fromJson(json['vehicleId'])
          : null,
      fromAr: json['fromAr'],
      toAr: json['toAr'],
      fromEn: json['fromEn'],
      toEn: json['toEn'],
      passengers: json['passengers'],
      price: json['price'],
      time: json['time'],
      countryCode: json['countryCode'],
      isRepeat: json['isRepeat'],
      status: json['status'],
      createdAt: json['createdAt'],
      views: json['views'],
    );
  }
}

class VehicleModel extends VehicleEntity {
  VehicleModel({
    super.id,
    super.brand,
    super.model,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['_id'],
      brand: json['Brand'],
      model: json['Model'],
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
