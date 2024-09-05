import 'driver_id.dart';
import 'driver_ratings_virtual.dart';
import 'is_user_rate.dart';

class ShippingRequestModel {
  String? id;
  DriverId? driverId;
  String? userId;
  String? categoryId;
  String? startLocation;
  String? targetLocation;
  String? status;
  double? price;
  String? time;
  String? desc;
  bool? isPremium;
  bool? adminIgnore;
  int? phone;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<DriverRatingsVirtual>? driverRatingsVirtual;
  IsUserRate? isUserRate;

  ShippingRequestModel({
    this.id,
    this.driverId,
    this.userId,
    this.categoryId,
    this.startLocation,
    this.targetLocation,
    this.status,
    this.price,
    this.time,
    this.desc,
    this.isPremium,
    this.adminIgnore,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.driverRatingsVirtual,
    this.isUserRate,
  });

  factory ShippingRequestModel.fromJson(Map<String, dynamic> json) {
    return ShippingRequestModel(
      id: json['_id'] as String?,
      driverId: json['driverId'] == null
          ? null
          : DriverId.fromJson(json['driverId'] as Map<String, dynamic>),
      userId: json['userId'] as String?,
      categoryId: json['categoryId'] as String?,
      startLocation: json['startLocation'] as String?,
      targetLocation: json['targetLocation'] as String?,
      status: json['status'] as String?,
      price: double.parse(json['price'].toString()),
      time: json['time'] as String?,
      desc: json['desc'] as String?,
      isPremium: json['isPremium'] as bool?,
      adminIgnore: json['adminIgnore'] as bool?,
      phone: json['phone'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      driverRatingsVirtual: (json['driverRatingsVirtual'] as List<dynamic>?)
          ?.map((e) => DriverRatingsVirtual.fromJson(e as Map<String, dynamic>))
          .toList(),
      isUserRate: json['isUserRate'] == null
          ? null
          : IsUserRate.fromJson(json['isUserRate'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'driverId': driverId?.toJson(),
        'userId': userId,
        'categoryId': categoryId,
        'startLocation': startLocation,
        'targetLocation': targetLocation,
        'status': status,
        'price': price,
        'time': time,
        'desc': desc,
        'isPremium': isPremium,
        'adminIgnore': adminIgnore,
        'phone': phone,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'driverRatingsVirtual':
            driverRatingsVirtual?.map((e) => e.toJson()).toList(),
        'isUserRate': isUserRate?.toJson(),
      };
}
