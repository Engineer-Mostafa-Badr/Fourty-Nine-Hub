import 'driver_id.dart';

class MyTripOfferRideModel {
  String? id;
  String? tripId;
  DriverId? driverId;
  String? status;
  int? price;
  String? subcategoryId;
  bool? isAccepted;
  bool? isRejected;
  bool? isPremium;
  DateTime? createdAt;
  DateTime? updatedAt;

  MyTripOfferRideModel({
    this.id,
    this.tripId,
    this.driverId,
    this.status,
    this.price,
    this.subcategoryId,
    this.isAccepted,
    this.isRejected,
    this.isPremium,
    this.createdAt,
    this.updatedAt,
  });

  factory MyTripOfferRideModel.fromJson(Map<String, dynamic> json) {
    return MyTripOfferRideModel(
      id: json['_id'] as String?,
      tripId: json['tripId'] as String?,
      driverId: json['driverId'] == null
          ? null
          : DriverId.fromJson(json['driverId'] as Map<String, dynamic>),
      status: json['status'] as String?,
      price: json['price'] as int?,
      subcategoryId: json['subcategoryId'] as String?,
      isAccepted: json['isAccepted'] as bool?,
      isRejected: json['isRejected'] as bool?,
      isPremium: json['isPremium'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'tripId': tripId,
        'driverId': driverId?.toJson(),
        'status': status,
        'price': price,
        'subcategoryId': subcategoryId,
        'isAccepted': isAccepted,
        'isRejected': isRejected,
        'isPremium': isPremium,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
