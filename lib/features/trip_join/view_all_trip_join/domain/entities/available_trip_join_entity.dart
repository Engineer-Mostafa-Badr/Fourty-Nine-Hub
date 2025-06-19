class AvailableTripJoinEntity {
  final bool? subscribedPremium;
  final List<TripJoinEntity>? trips;

  AvailableTripJoinEntity({
    this.subscribedPremium,
    this.trips,
  });
}

class TripJoinEntity {
  final int? views;
  final String? id;
  final String? userId;
  final String? categoryId;
  final VehicleEntity? vehicle;  // تعديل هنا
  final String? fromAr;
  final String? toAr;
  final String? fromEn;
  final String? toEn;
  final int? distance;
  final int? duration;
  final int? passengers;
  final int? price;
  final String? phone;
  final int? time;
  final String? countryCode;
  final int? countRequests;
  final bool? isRepeat;
  final String? status;
  final int? statusPriority;
  final bool? adminIgnore;
  final String? createdAt;
  final String? updatedAt;
  final bool? isOwner;
  final String? allowStatus;
  final String? paymentMethods;

  TripJoinEntity({
    this.views,
    this.id,
    this.userId,
    this.categoryId,
    this.vehicle,  // تعديل هنا
    this.fromAr,
    this.toAr,
    this.fromEn,
    this.toEn,
    this.distance,
    this.duration,
    this.passengers,
    this.price,
    this.phone,
    this.time,
    this.countryCode,
    this.countRequests,
    this.isRepeat,
    this.status,
    this.statusPriority,
    this.adminIgnore,
    this.createdAt,
    this.updatedAt,
    this.isOwner,
    this.allowStatus,
    this.paymentMethods,
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
