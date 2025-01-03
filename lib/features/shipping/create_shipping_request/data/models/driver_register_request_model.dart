class DriverRegisterRequestModel {
  final String categoryId;
  final String carModel;
  final String firstName;
  final String lastName;
  final String location;
  final String phone;
  final String idNumber;
  final String plateInformation;
  DriverRegisterRequestModel({
    required this.categoryId,
    required this.carModel,
    required this.idNumber,
    required this.plateInformation,
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.phone,
  });

  Map<String, dynamic> register() {
    return {
      "categoryId": categoryId,
      "carModel": carModel, // car model string
      "firstName": firstName,
      "lastName": lastName,
      "location": location,
      "phone": phone,
      "plateInformation": plateInformation,
      "idNumber": idNumber
    };
  }
}
