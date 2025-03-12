import 'package:equatable/equatable.dart';

class UserTripEntity  {
  final String sId;
  final String driverId;
  final String userId;
  final String categoryId;
  final String startLocation;
  final String targetLocation;
  final String status;
  final int price;
  final String time;
  final String desc;
  final bool isPremium;
  final bool adminIgnore;
  final String phone;
  final double rate;
  final CurrencyEntity currency;
  final double isUserRate;

  const UserTripEntity({
    required  this.sId,
    required  this.driverId,
    required  this.userId,
    required  this.categoryId,
    required  this.startLocation,
    required  this.targetLocation,
    required   this.status,
    required   this.price,
    required this.time,
    required  this.desc,
    required  this.isPremium,
    required  this.adminIgnore,
    required  this.phone,
    required  this.rate,
    required  this.currency,
    required  this.isUserRate,
  });

  List<Object> get props {
    return [
      sId,
      driverId,
      userId,
      categoryId,
      startLocation,
      targetLocation,
      status,
      price,
      time,
      desc,
      isPremium,
      adminIgnore,
      phone,
      rate,
      currency,
      isUserRate,
    ];
  }
}

class CurrencyEntity extends Equatable {
  final String currencyEn;
  final String currencyAr;

  @override
  List<Object> get props {
    return [
      currencyEn,
      currencyAr,
    ];
  }

  const CurrencyEntity({
   required this.currencyEn,
    required this.currencyAr,
  });
}
