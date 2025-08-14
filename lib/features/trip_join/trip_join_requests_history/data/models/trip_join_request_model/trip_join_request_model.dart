import '../../../domain/entities/tripjoin_request_entity.dart';

import 'category_id.dart';
import 'user_id.dart';
import 'vehicle_id.dart';

class TripJoinMyRequestModel extends TripJoinMyRequestEntity {
  @override
  String? id;
  UserId? userId;
  CategoryId? categoryId;
  VehicleId? vehicleId;
  String? fromAr;
  String? toAr;
  String? fromEn;
  String? toEn;
  num? distance;
  num? duration;
  num? passengers;
  num? price;
  String? phone;
  num? time;
  String? countryCode;
  List<dynamic>? calls;
  bool? isRepeat;
  @override
  String? status;
  bool? adminIgnore;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? countRequests;
  TripJoinMyRequestModel({
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
    this.calls,
    this.isRepeat,
    this.status,
    this.adminIgnore,
    this.createdAt,
    this.updatedAt,
    this.countRequests,
  }) : super(
          id: id,
          categoryMainId: categoryId?.id,
          brand: vehicleId?.brand,
          model: vehicleId?.model,
          journeyPrice: price,
          status: status,
          seatNumber: passengers?.toInt(),
          isRepeated: isRepeat,
          startingAddressAr: fromAr,
          destinationAddressAr: toAr,
          startingAddressEn: fromEn,
          destinationAddressEn: toEn,
          publishDate: time?.toInt(),
          paymentMethod: categoryId?.paymentMethods,
        );

  @override
  String toString() {
    return 'TripJoinMyRequestModel(id: $id, userId: $userId, categoryId: $categoryId, vehicleId: $vehicleId, fromAr: $fromAr, toAr: $toAr, fromEn: $fromEn, toEn: $toEn, distance: $distance, duration: $duration, passengers: $passengers, price: $price, phone: $phone, time: $time, countryCode: $countryCode, calls: $calls, isRepeat: $isRepeat, status: $status, adminIgnore: $adminIgnore, createdAt: $createdAt, updatedAt: $updatedAt, countRequests: $countRequests)';
  }

  factory TripJoinMyRequestModel.fromJson(Map<String, dynamic> json) {
    return TripJoinMyRequestModel(
      id: json['_id'] as String?,
      userId: json['userId'] == null
          ? null
          : UserId.fromJson(json['userId'] as Map<String, dynamic>),
      categoryId: json['categoryId'] == null
          ? null
          : CategoryId.fromJson(json['categoryId'] as Map<String, dynamic>),
      vehicleId: json['vehicleId'] == null
          ? null
          : VehicleId.fromJson(json['vehicleId'] as Map<String, dynamic>),
      fromAr: json['fromAr'] as String?,
      toAr: json['toAr'] as String?,
      fromEn: json['fromEn'] as String?,
      toEn: json['toEn'] as String?,
      distance: json['distance'] as num?,
      duration: json['duration'] as num?,
      passengers: json['passengers'] as num?,
      price: json['price'] as num?,
      phone: json['phone'] as String?,
      time: json['time'] as num?,
      countryCode: json['countryCode'] as String?,
      calls: json['calls'] as List<dynamic>?,
      isRepeat: json['isRepeat'] as bool?,
      status: json['status'] as String?,
      adminIgnore: json['adminIgnore'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      countRequests: json['countRequests'] as num?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId?.toJson(),
        'categoryId': categoryId?.toJson(),
        'vehicleId': vehicleId?.toJson(),
        'fromAr': fromAr,
        'toAr': toAr,
        'fromEn': fromEn,
        'toEn': toEn,
        'distance': distance,
        'duration': duration,
        'passengers': passengers,
        'price': price,
        'phone': phone,
        'time': time,
        'countryCode': countryCode,
        'calls': calls,
        'isRepeat': isRepeat,
        'status': status,
        'adminIgnore': adminIgnore,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'countRequests': countRequests,
      };
}
