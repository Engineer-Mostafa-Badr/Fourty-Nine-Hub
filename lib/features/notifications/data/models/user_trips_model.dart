import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/user_trip_entity.dart';

class UserTripsModel extends UserTripEntity {
  UserTripsModel({
    required super.sId,
    required super.driverId,
    required super.userId,
    required super.categoryId,
    required super.startLocation,
    required super.targetLocation,
    required super.status,
    required super.price,
    required super.time,
    required super.desc,
    required super.isPremium,
    required super.adminIgnore,
    required super.phone,
    required super.rate,
    required super.currency,
    required super.isUserRate,
  });

  factory UserTripsModel.fromJson(Map<String, dynamic> json) {

    return UserTripsModel(
      sId: json['_id'],
      driverId: json['driverId']??'',
      userId: json['userId'],
      categoryId: json['categoryId'],
      startLocation: json['startLocation'],
      targetLocation: json['targetLocation'],
      status: json['status'],
      price: json['price'],
      time: json['time'],
      desc: json['desc'],
      isPremium: json['isPremium'],
      adminIgnore: json['adminIgnore'],
      phone: json['phone'],
      rate: json['rate']??0.0,
      currency: CurrencyModel.fromJson(json['currency']),
      isUserRate: json['isUserRate']??0.0,
    );
  }
}

class CurrencyModel extends CurrencyEntity {
  const CurrencyModel({required super.currencyEn, required super.currencyAr});

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      currencyEn: json['currencyEn'],
      currencyAr: json['currencyAr'],
    );
  }
}
