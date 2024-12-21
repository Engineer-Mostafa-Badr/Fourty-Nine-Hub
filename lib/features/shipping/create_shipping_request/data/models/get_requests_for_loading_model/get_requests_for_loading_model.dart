import 'driver_id.dart';

class GetRequestsForLoadingModel {
  String? id;
  DriverId? driverId;
  String? loadingTripId;
  double? price;
  bool? isAccepted;
  bool? isRejected;
  bool? isPremium;
  DateTime? createdAt;
  DateTime? updatedAt;
  
  GetRequestsForLoadingModel({
    this.id,
    this.driverId,
    this.loadingTripId,
    this.price,
    this.isAccepted,
    this.isRejected,
    this.isPremium,
    this.createdAt,
    this.updatedAt,
  });

  factory GetRequestsForLoadingModel.fromJson(Map<String, dynamic> json) {
    return GetRequestsForLoadingModel(
      id: json['_id'] as String?,
      driverId: json['driverId'] == null
          ? null
          : DriverId.fromJson(json['driverId'] as Map<String, dynamic>),
      loadingTripId: json['loadingTripId'] as String?,
      price: double.parse(json['price'].toString()),
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
        'driverId': driverId?.toJson(),
        'loadingTripId': loadingTripId,
        'price': price,
        'isAccepted': isAccepted,
        'isRejected': isRejected,
        'isPremium': isPremium,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
