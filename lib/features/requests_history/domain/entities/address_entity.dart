class AddressEntity {
 final String id;
 final  List<double> coordinates;
 final  String address;
  final String street;
  final String flat;
  final String building;
  final String firstName;
  final String lastName;
 final  String phone;

  AddressEntity(
      {required this.id,
      required this.coordinates,
     required  this.address,
     required  this.street,
     required  this.flat,
     required  this.building,
     required  this.firstName,
     required  this.lastName,
     required  this.phone});
}
