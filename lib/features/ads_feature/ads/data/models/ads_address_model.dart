import '../../domain/entities/ads_address_entity.dart';

class AdsAddressModel extends AdsAddressEntity {
  const AdsAddressModel({
    required super.governmentAr,
    required super.governmentEn,
    required super.cityAr,
    required super.cityEn,
    required super.addressAr,
    required super.addressEn,
    required super.coordinates,
  });

  factory AdsAddressModel.fromJson(Map<String, dynamic> json) =>
      AdsAddressModel(
        governmentAr: json['government'] != null && json['government'] is Map
            ? json['government']['governorate_name_ar'] ?? ''
            : '',
        governmentEn: json['government'] != null && json['government'] is Map
            ? json['government']['governorate_name_en'] ?? ''
            : '',
        cityAr: json['city'] != null && json['city'] is Map
            ? json['city']['city_name_ar'] ?? ''
            : '',
        cityEn: json['city'] != null && json['city'] is Map
            ? json['city']['city_name_en'] ?? ''
            : '',
        addressAr: json['city'] != null &&
                json['city'] is Map &&
                json['government'] != null &&
                json['government'] is Map
            ? '${json['city']['city_name_ar'] ?? 'N/A'}, ${json['government']['governorate_name_ar'] ?? 'N/A'}'
            : 'N/A',
        addressEn: json['city'] != null &&
                json['city'] is Map &&
                json['government'] != null &&
                json['government'] is Map
            ? '${json['city']['city_name_en'] ?? 'N/A'}, ${json['government']['governorate_name_en'] ?? 'N/A'}'
            : 'N/A',
        coordinates: json['coordinates'] != null
            ? json['coordinates'].cast<double>()
            : [],
      );
}
