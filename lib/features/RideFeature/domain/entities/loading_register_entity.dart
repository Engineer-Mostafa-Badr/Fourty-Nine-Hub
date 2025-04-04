class LoadingRegisterEntity {
  final String categoryId;
  final String carModel;
  final String firstName;
  final String lastName;
  final String location;
  final String phone;
  final String plateInformation;
  final String idNumber;

  LoadingRegisterEntity({
    required this.categoryId,
    required this.carModel,
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.phone,
    required this.plateInformation,
    required this.idNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "categoryId": categoryId,
      "carModel": carModel,
      "firstName": firstName,
      "lastName": lastName,
      "location": location,
      "phone": phone,
      "plateInformation": plateInformation,
      "idNumber": idNumber,
    };
  }

  //fromJson
  factory LoadingRegisterEntity.fromJson(Map<String, dynamic> json) {
    return LoadingRegisterEntity(
      categoryId: json["categoryId"],
      carModel: json["carModel"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      location: json["location"],
      phone: json["phone"],
      plateInformation: json["plateInformation"],
      idNumber: json["idNumber"],
    );
  }
}