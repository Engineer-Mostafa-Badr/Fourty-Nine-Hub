import '../../../domain/entities/available_trip_join_entity.dart';

class AvailableTripJoinModel extends AvailableTripJoinEntity {
  AvailableTripJoinModel({
    bool? subscribedPremium,
    List<TripJoinModel>? trips,
  }) : super(
    subscribedPremium: subscribedPremium,
    trips: trips,
  );

  factory AvailableTripJoinModel.fromJson(Map<String, dynamic> json) {
    return AvailableTripJoinModel(
      subscribedPremium: json['subscribedPremium'] as bool?,
      trips: (json['Trips'] as List<dynamic>?)
          ?.map((e) => TripJoinModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TripJoinModel extends TripJoinEntity {
  TripJoinModel({
    int? views,
    String? id,
    String? userId,
    String? categoryId,
    VehicleModel? vehicle,
    String? fromAr,
    String? toAr,
    String? fromEn,
    String? toEn,
    int? distance,
    int? duration,
    int? passengers,
    int? price,
    String? phone,
    int? time,
    String? countryCode,
    int? countRequests,
    bool? isRepeat,
    String? status,
    int? statusPriority,
    bool? adminIgnore,
    String? createdAt,
    String? updatedAt,
    bool? isOwner,
    String? allowStatus,
    String? paymentMethods,
  }) : super(
    views: views,
    id: id,
    userId: userId,
    categoryId: categoryId,
    vehicle: vehicle,
    fromAr: fromAr,
    toAr: toAr,
    fromEn: fromEn,
    toEn: toEn,
    distance: distance,
    duration: duration,
    passengers: passengers,
    price: price,
    phone: phone,
    time: time,
    countryCode: countryCode,
    countRequests: countRequests,
    isRepeat: isRepeat,
    status: status,
    statusPriority: statusPriority,
    adminIgnore: adminIgnore,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isOwner: isOwner,
    allowStatus: allowStatus,
    paymentMethods: paymentMethods,
  );

  factory TripJoinModel.fromJson(Map<String, dynamic> json) {
    return TripJoinModel(
      views: (json['views'] as num?)?.toInt(),
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      categoryId: json['categoryId'] as String?,
      vehicle: json['vehicleId'] != null
          ? (json['vehicleId'] is Map<String, dynamic>
          ? VehicleModel.fromJson(json['vehicleId'])
          : null)
          : null,
      fromAr: json['fromAr'] as String?,
      toAr: json['toAr'] as String?,
      fromEn: json['fromEn'] as String?,
      toEn: json['toEn'] as String?,
      distance: (json['distance'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      passengers: (json['passengers'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
      phone: json['phone'] as String?,
      time: (json['time'] as num?)?.toInt(),
      countryCode: json['countryCode'] as String?,
      countRequests: (json['countRequests'] as num?)?.toInt(),
      isRepeat: json['isRepeat'] as bool?,
      status: json['status'] as String?,
      statusPriority: (json['statusPriority'] as num?)?.toInt(),
      adminIgnore: json['adminIgnore'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      isOwner: json['isOwner'] as bool?,
      allowStatus: json['allowStatus'] as String?,
      paymentMethods: json['paymentMethods'] as String?,
    );
  }


}

class VehicleModel extends VehicleEntity {
  VehicleModel({
    String? id,
    String? brand,
    String? model,
  }) : super(
    id: id,
    brand: brand,
    model: model,
  );

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['_id'] as String?,
      brand: json['Brand'] as String?,
      model: json['Model'] as String?,
    );
  }
}
