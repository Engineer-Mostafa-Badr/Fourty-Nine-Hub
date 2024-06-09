import '../../domain/entity/address_search_params_entity.dart';

class AddressSearchParamsModel extends AddressSearchParamsEntity {
  AddressSearchParamsModel({required super.address, required super.lat, required super.lng});
   Map<String, dynamic> toJson() => {
        'key': address, 
        'lat':lat, 
        'lng':lng,
    };
}
