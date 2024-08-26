import 'dart:developer';

import 'category_id.dart';
import 'goods_picture.dart';
import 'user_id.dart';

class AllTripModel {
  bool? adminIgnore;
  String? id;
  dynamic driverId;
  UserId? userId;
  CategoryId? categoryId;
  String? startLocation;
  String? targetLocation;
  String? status;
  List<GoodsPicture>? goodsPicture;
  double? price;
  String? time;
  String? desc;
  bool? isPremium;
  int? phone;
  DateTime? createdAt;
  DateTime? updatedAt;

  AllTripModel({
    this.adminIgnore,
    this.id,
    this.driverId,
    this.userId,
    this.categoryId,
    this.startLocation,
    this.targetLocation,
    this.status,
    this.goodsPicture,
    this.price,
    this.time,
    this.desc,
    this.isPremium,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  factory AllTripModel.fromJson(Map<String, dynamic> json) {
    log(json['startLocation'].toString(),
        name: "lksdjlskjdflskjdflskdjflskdjflsj");
    return AllTripModel(
      adminIgnore: json['adminIgnore'] as bool?,
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
      goodsPicture: (json['goodsPicture'] as List<dynamic>?)
          ?.map((e) => GoodsPicture.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: double.parse(json['price'].toString()),
      time: json['time'] as String?,
      desc: json['desc'] as String?,
      isPremium: json['isPremium'] as bool?,
      phone: json['phone'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      id: json['id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'adminIgnore': adminIgnore,
        '_id': id,
        'driverId': driverId,
        'userId': userId?.toJson(),
        'categoryId': categoryId?.toJson(),
        'startLocation': startLocation,
        'targetLocation': targetLocation,
        'status': status,
        'goodsPicture': goodsPicture?.map((e) => e.toJson()).toList(),
        'price': price,
        'time': time,
        'desc': desc,
        'isPremium': isPremium,
        'phone': phone,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'id': id,
      };
}
