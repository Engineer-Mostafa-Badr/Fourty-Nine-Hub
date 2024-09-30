import 'category_id.dart';
import 'user_id.dart';

class Trip {
  String? id;
  UserId? userId;
  CategoryId? categoryId;
  String? fromEn;
  String? toEn;
  String? fromAr;
  String? toAr;
  num? distance;
  num? duration;
  num? price;
  String? phone;
  num? time;
  bool? isRepeat;

  Trip({
    this.id,
    this.userId,
    this.categoryId,
    this.fromEn,
    this.toEn,
    this.fromAr,
    this.toAr,
    this.distance,
    this.duration,
    this.price,
    this.phone,
    this.time,
    this.isRepeat,
  });

  @override
  String toString() {
    return 'Trip(id: $id, userId: $userId, categoryId: $categoryId, fromEn: $fromEn, toEn: $toEn, fromAr: $fromAr, toAr: $toAr, distance: $distance, duration: $duration, price: $price, phone: $phone, time: $time, isRepeat: $isRepeat)';
  }

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json['_id'] as String?,
        userId: json['userId'] == null ? null : UserId.fromJson(json['userId'] as Map<String, dynamic>),
        categoryId: json['categoryId'] == null ? null : CategoryId.fromJson(json['categoryId'] as Map<String, dynamic>),
        fromEn: json['fromEn'] as String?,
        toEn: json['toEn'] as String?,
        fromAr: json['fromAr'] as String?,
        toAr: json['toAr'] as String?,
        distance: json['distance'] as num?,
        duration: json['duration'] as num?,
        price: json['price'] as num?,
        phone: json['phone']?.toString(),
        time: json['time'] as num?,
        isRepeat: json['isRepeat'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId?.toJson(),
        'categoryId': categoryId?.toJson(),
        'fromEn': fromEn,
        'toEn': toEn,
        'fromAr': fromAr,
        'toAr': toAr,
        'distance': distance,
        'duration': duration,
        'price': price,
        'phone': phone,
        'time': time,
        'isRepeat': isRepeat,
      };
}
