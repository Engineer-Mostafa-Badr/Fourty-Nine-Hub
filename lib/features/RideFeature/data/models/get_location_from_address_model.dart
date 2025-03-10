import 'package:fourtyninehub/features/RideFeature/domain/entities/get_location_from_address_entity.dart';

class GetLocationFromAddressModel extends GetLocationFromAddressEntity{

  GetLocationFromAddressModel({required super.lat, required super.lng, required super.address, required super.type});
  factory GetLocationFromAddressModel.fromJson(Map<String, dynamic> json) => GetLocationFromAddressModel(lat: json["lat"], lng: json["lng"], address: json["address"], type: json["type"]);
}