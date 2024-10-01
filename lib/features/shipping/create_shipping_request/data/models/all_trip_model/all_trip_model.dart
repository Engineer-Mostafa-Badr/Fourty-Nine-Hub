import 'dart:developer';

import 'goods_picture.dart';

class AllTripModel {
  bool? adminIgnore;
  String? id;
  dynamic driverId;
  String? userId;
  String? categoryId;
  String? startLocation;
  String? targetLocation;
  String? status;
  List<GoodsPicture>? goodsPicture;
  double? price;
  String? time;
  String? desc;
  bool? isPremium;
  bool? acceptedReq;
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
    this.acceptedReq,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  factory AllTripModel.fromJson(Map<String, dynamic> json) {
    log(json['startLocation'].toString(),
        name: "lksdjlskjdflskjdflskdjflskdjflsj");
    return AllTripModel(
      acceptedReq: json['acceptedReq'] as bool?,
      adminIgnore: json['adminIgnore'] as bool?,
      driverId: json['driverId'] as dynamic,
      userId: json['userId'] as String?,
      categoryId: json['categoryId'] as String?,
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
        'userId': userId,
        'categoryId': categoryId,
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
