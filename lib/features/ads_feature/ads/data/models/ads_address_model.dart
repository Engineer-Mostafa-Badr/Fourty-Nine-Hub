import '../../domain/entities/ads_address_entity.dart';

class AdsAddressModel extends AdsAddressEntity {
  const AdsAddressModel({
    required super.government,
    required super.city,
    required super.coordinates,
    required super.address,
  });

  factory AdsAddressModel.fromJson(Map<String, dynamic> json) =>
      AdsAddressModel(
        government: json['government'],
        city: json['city'],
        address: '${json['government']}, ${json['city']}',
        coordinates: json['coordinates'].cast<double>(),
      );
}
