import 'package:fourtyninehub/features/register/driver_register/domain/entities/rider_info_entity.dart';

class RiderInfoModel extends RiderInfoEntity {
  RiderInfoModel(
      {required super.subcategoryId,
      required super.vehicleTypeId,
      required super.countryCode,
      required super.pricingPerKm,
      required super.phone});
  factory RiderInfoModel.fromJson(Map<String, dynamic> json) {
    return RiderInfoModel(
      subcategoryId: json['subcategoryId'],
      vehicleTypeId: json['vehicleTypeId'],
      countryCode: json['countryCode'],
      pricingPerKm: json['pricingPerKm'],
      phone: json['phone'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subcategoryId'] = subcategoryId;
    data['vehicleTypeId'] = vehicleTypeId;
    data['countryCode'] = countryCode;
    data['pricingPerKm'] = pricingPerKm;
    data['phone'] = phone;
    return data;
  }
}
