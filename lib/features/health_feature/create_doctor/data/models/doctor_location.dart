import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_locatoin.dart';

class DoctorLocationModel extends DoctorLocationEntity {
  DoctorLocationModel({required super.governorate, required super.city, required super.address});

  factory DoctorLocationModel.fromJson(Map<String, dynamic> json) {
    return DoctorLocationModel(
      governorate: json['governorate'],
      city: json['city'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['governorate'] = governorate;
    data['city'] = city;
    data['address'] = address;
    return data;
  }
}
