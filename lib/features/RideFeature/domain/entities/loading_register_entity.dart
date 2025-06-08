class LoadingRegisterEntity {
  final String categoryId;
  final String firstName;
  final String lastName;
  final String location;
  final String phone;
  final String plateInformation;
  final String idNumber;
  final String vehicleModel;
  final String vehicleBrand;
  final String vehicleYear;
  final String vehicleColor;


  LoadingRegisterEntity({
    required this.categoryId,
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.phone,
    required this.plateInformation,
    required this.idNumber,
    required this.vehicleModel,
    required this.vehicleBrand,
    required this.vehicleYear,
    required this.vehicleColor,
  });

  Map<String, dynamic> toJson() {
    return {
      "categoryId":categoryId,
      "carModelId": vehicleModel,
      "carBrandId": vehicleBrand,
      "carColor": vehicleColor,
      "carYear": vehicleYear,
      "firstName":firstName,
      "lastName":lastName,
      "location": location,
      "phone":phone,
      "plateInformation": plateInformation,
      "idNumber" : idNumber,
    };
  }

  //fromJson
  factory LoadingRegisterEntity.fromJson(Map<String, dynamic> json) {
    return LoadingRegisterEntity(
      categoryId: json["categoryId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      location: json["location"],
      phone: json["phone"],
      plateInformation: json["plateInformation"],
      idNumber: json["idNumber"],
      vehicleModel: json['carModelId'],
      vehicleBrand: json['carBrandId'],
      vehicleYear: json['carYear'],
      vehicleColor: json['carColor'],

    );
  }
}