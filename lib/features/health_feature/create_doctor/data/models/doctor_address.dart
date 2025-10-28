import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_address.dart';

class DoctorAddressModel extends DoctorAddressEntity {
  DoctorAddressModel(
      {required super.governorateId,
      required super.cityId,
      required super.address,
      super.latitude,
      super.longitude});

  factory DoctorAddressModel.fromJson(Map<String, dynamic> json) {
    return DoctorAddressModel(
      governorateId: json['governorateId'] ??
          (json['governorate'] is String
              ? json['governorate']
              : json['governorate']?['_id'] ?? ''),
      cityId: json['cityId'] ??
          (json['city'] is String ? json['city'] : json['city']?['_id'] ?? ''),
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['governorateId'] = governorateId;
    data['cityId'] = cityId;
    data['address'] = address;
    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;
    return data;
  }
}
