
import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  AddressModel({required super.id, required super.coordinates, required super.address, required super.street, required super.flat, required super.building, required super.firstName, required super.lastName, required super.phone});
  factory AddressModel.fromJson(Map<String, dynamic> json){
    return AddressModel(
      id: json['id'],
      coordinates: json['coordinates'].cast<double>(),
    address: json['address'],
    street: json['street'],
    flat: json['flat'],
    building: json['building'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    phone: json['phone'],

    );
  }
}
