import 'user_id.dart';

class AllTripNoSocketModel {
  dynamic driverId;
  String? id;
  UserId? userId;
  dynamic riderId;
  String? categoryId;
  String? fromTitle;
  String? toTitle;
  int? profit;
  bool? isPremium;
  int? passengers;
  double? price;
  String? status;
  int? penalty;
  bool? payedPenalty;
  bool? isUserGetCashback;
  bool? isRiderGetCashback;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? time;
  bool? acceptedReq;
  AllTripNoSocketModel({
    this.driverId,
    this.id,
    this.userId,
    this.riderId,
    this.categoryId,
    this.fromTitle,
    this.acceptedReq,
    this.toTitle,
    this.time,
    this.profit,
    this.isPremium,
    this.price,
    this.status,
    this.penalty,
    this.payedPenalty,
    this.isUserGetCashback,
    this.isRiderGetCashback,
    this.passengers,
    this.createdAt,
    this.updatedAt,
  });

  factory AllTripNoSocketModel.fromJson(Map<String, dynamic> json) {
    return AllTripNoSocketModel(
      driverId: json['driverId'] as dynamic,
      id: json['_id'] as String?,
      userId: json['userId'] == null
          ? null
          : UserId.fromJson(json['userId'] as Map<String, dynamic>),
      riderId: json['riderId'] as dynamic,
      categoryId: json['categoryId'] as String?,
      time: json['time'] as String?,
      fromTitle: json['fromTitle'] as String?,
      toTitle: json['toTitle'] as String?,
      acceptedReq: json['acceptedReq'] as bool?,
      profit: json['profit'] as int?,
      isPremium: json['isPremium'] as bool?,
      price: double.parse(json['price'].toString()),
      status: json['status'] as String?,
      penalty: json['penalty'] as int?,
      passengers: json['passengers'] as int?,
      payedPenalty: json['payed_penalty'] as bool?,
      isUserGetCashback: json['isUserGetCashback'] as bool?,
      isRiderGetCashback: json['isRiderGetCashback'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'driverId': driverId,
        '_id': id,
        'userId': userId?.toJson(),
        'riderId': riderId,
        'categoryId': categoryId,
        'fromTitle': fromTitle,
        'toTitle': toTitle,
        'profit': profit,
        'isPremium': isPremium,
        'price': price,
        'status': status,
        'penalty': penalty,
        'payed_penalty': payedPenalty,
        'isUserGetCashback': isUserGetCashback,
        'isRiderGetCashback': isRiderGetCashback,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
