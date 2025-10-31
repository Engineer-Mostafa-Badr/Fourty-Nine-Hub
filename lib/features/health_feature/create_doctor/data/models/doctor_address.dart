import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_address.dart';

class DoctorAddressModel extends DoctorAddressEntity {
  DoctorAddressModel(
      {required super.governorateId,
      required super.cityId,
      required super.address,
      super.latitude,
      super.longitude,
      super.governorateNameAr,
      super.governorateNameEn,
      super.cityNameAr,
      super.cityNameEn});

  factory DoctorAddressModel.fromJson(Map<String, dynamic> json) {
    final gov = json['governorate'];
    final city = json['city'];
    return DoctorAddressModel(
      governorateId:
          json['governorateId'] ?? (gov is String ? gov : gov?['_id'] ?? ''),
      cityId: json['cityId'] ?? (city is String ? city : city?['_id'] ?? ''),
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      governorateNameAr:
          (gov is Map<String, dynamic>) ? gov['governorateNameAr'] : null,
      governorateNameEn:
          (gov is Map<String, dynamic>) ? gov['governorateNameEn'] : null,
      cityNameAr: (city is Map<String, dynamic>) ? city['cityNameAr'] : null,
      cityNameEn: (city is Map<String, dynamic>) ? city['cityNameEn'] : null,
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
