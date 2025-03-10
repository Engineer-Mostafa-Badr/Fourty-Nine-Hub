import 'package:fourtyninehub/features/RideFeature/data/models/helpers/currency.dart';

class CurrentTripEntity {
  final String? id;
  final String? categoryPicture;
  final String? categoryNameEn;
  final String? categoryNameAr;
  final String? to;
  final String? from;
  final String? time;
  final DateTime? createdAt;
  final double? price;
  final String? status;
  final String? car;
  final Currency? currency;
  final String? driverFirstName;

  CurrentTripEntity({
    this.id,
    this.categoryPicture,
    this.categoryNameEn,
    this.categoryNameAr,
    this.to,
    this.from,
    this.time,
    this.createdAt,
    this.price,
    this.status,
    this.car,
    this.currency,
    this.driverFirstName,
  });
}