import 'category_id.dart';
import 'user_id.dart';

class AllTripModel {
  String? id;
  dynamic driverId;
  UserId? userId;
  CategoryId? categoryId;
  String? startLocation;
  String? targetLocation;
  String? status;
  double? price;
  String? time;
  String? desc;
  bool? isPremium;
  DateTime? createdAt;
  DateTime? updatedAt;

  AllTripModel({
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
    this.createdAt,
    this.updatedAt,
  });

  factory AllTripModel.fromJson(Map<String, dynamic> json) => AllTripModel(
        driverId: json['driverId'] as dynamic,
        userId: json['userId'] == null
            ? null
            : UserId.fromJson(json['userId'] as Map<String, dynamic>),
        categoryId: json['categoryId'] == null
            ? null
            : CategoryId.fromJson(json['categoryId'] as Map<String, dynamic>),
        startLocation: json['startLocation'] as String?,
        targetLocation: json['targetLocation'] as String?,
        status: json['status'] as String?,
        price: double.parse(json['price'].toString()),
        time: json['time'] as String?,
        desc: json['desc'] as String?,
        isPremium: json['isPremium'] as bool?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        id: json['id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'driverId': driverId,
        'userId': userId?.toJson(),
        'categoryId': categoryId?.toJson(),
        'startLocation': startLocation,
        'targetLocation': targetLocation,
        'status': status,
        'price': price,
        'time': time,
        'desc': desc,
        'isPremium': isPremium,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'id': id,
      };
}
