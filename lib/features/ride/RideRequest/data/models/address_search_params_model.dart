import '../../domain/entity/address_search_params_entity.dart';

class AddressSearchParamsModel extends AddressSearchParamsEntity {
  AddressSearchParamsModel(
      {required super.address, required super.lat, required super.lng});

  factory AddressSearchParamsModel.fromJson(Map<String, dynamic> json) {
    return AddressSearchParamsModel(
      address: json['address'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }

  Map<String, dynamic> toJson() => {
        'address': address,
        'lat': lat,
        'lng': lng,
      };
}
