import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';

import 'vehicle_id.dart';

class TripJoinCardModel extends TripJoinCardEntity {
  @override
  String? id;
  @override
  String? userId;
  @override
  String? categoryId;
  VehicleId? vehicleId;
  String? fromAr;
  String? toAr;
  String? fromEn;
  String? toEn;
  int? distance;
  int? duration;
  int? passengers;
  double? price;
  @override
  String? phone;
  int? time;
  String? countryCode;
  @override
  bool? isApproved;
  @override
  String? status;
  bool? isRepeat;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? allowStatus;

  TripJoinCardModel({
    this.id,
    this.userId,
    this.categoryId,
    this.vehicleId,
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
    this.isApproved,
    this.isRepeat,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.allowStatus,
  }) : super(
          id: id,
          userId: userId,
          categoryId: categoryId,
          brand: vehicleId?.brand,
          model: vehicleId?.model,
          journeyPrice: price,
          status: status,
          seatNumber: passengers,
          isRepeated: isRepeat,
          startingAddressAr: fromAr,
          destinationAddressAr: toAr,
          startingAddressEn: fromEn,
          destinationAddressEn: toEn,
          isApproved: allowStatus == 'enable',
          publishDate: time,
        );

  @override
  String toString() {
    return 'TripJoinCardModel(id: $id, userId: $userId, categoryId: $categoryId, vehicleId: $vehicleId, fromAr: $fromAr, toAr: $toAr, fromEn: $fromEn, toEn: $toEn, distance: $distance, duration: $duration, passengers: $passengers, price: $price, phone: $phone, time: $time, countryCode: $countryCode, isApproved: $isApproved, isRepeat: $isRepeat, createdAt: $createdAt, updatedAt: $updatedAt , status: $status, allowStatus: $allowStatus)';
  }

  factory TripJoinCardModel.fromJson(Map<String, dynamic> json) {
    return TripJoinCardModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      categoryId: json['categoryId'] as String?,
      vehicleId: json['vehicleId'] == null
          ? null
          : VehicleId.fromJson(json['vehicleId'] as Map<String, dynamic>),
      fromAr: json['fromAr'] as String?,
      toAr: json['toAr'] as String?,
      fromEn: json['fromEn'] as String?,
      toEn: json['toEn'] as String?,
      status: json['status'] as String?,
      distance: json['distance'] as int?,
      duration: json['duration'] as int?,
      passengers: json['passengers'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      phone: json['phone'].toString(),
      time: json['time'] as int?,
      countryCode: json['countryCode'] as String?,
      isApproved: json['isApproved'] as bool?,
      isRepeat: json['isRepeat'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      allowStatus: json['allowStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'categoryId': categoryId,
        'vehicleId': vehicleId?.toJson(),
        'fromAr': fromAr,
        'toAr': toAr,
        'fromEn': fromEn,
        'toEn': toEn,
        'status': status,
        'distance': distance,
        'duration': duration,
        'passengers': passengers,
        'price': price,
        'phone': phone,
        'time': time,
        'countryCode': countryCode,
        'isApproved': isApproved,
        'isRepeat': isRepeat,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'allowStatus': allowStatus,
      };
}
