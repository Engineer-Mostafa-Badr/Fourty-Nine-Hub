import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_address.dart';

class DoctorAddressModel extends DoctorAddressEntity {
  DoctorAddressModel(
      {required super.governorateId,
      required super.cityId,
      required super.address});

  factory DoctorAddressModel.fromJson(Map<String, dynamic> json) {
    return DoctorAddressModel(
      governorateId: json['governorate'] ?? '',
      cityId: json['city'] ?? '',
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
