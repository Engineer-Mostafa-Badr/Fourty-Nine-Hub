import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_address.dart';

class DoctorAddressModel extends DoctorAddressEntity {
  DoctorAddressModel(
      {required super.governorateId,
      required super.cityId,
      required super.address});

  factory DoctorAddressModel.fromJson(Map<String, dynamic> json) {
    return DoctorAddressModel(
      governorateId: json['governorate'] is String?json['governorate']:json['governorate']['_id'] ?? '',
      cityId:  json['city'] is String?  json['city']:json['city']['_id'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['governorate'] = governorateId;
    data['city'] = cityId;
    data['address'] = address;
    return data;
  }
}
