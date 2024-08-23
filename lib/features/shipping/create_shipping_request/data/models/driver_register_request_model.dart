class DriverRegisterRequestModel {
  final String categoryId;
  final String carModel;
  final String firstName;
  final String lastName;
  final String location;
  final String phone;
  final String governorate;

  DriverRegisterRequestModel(
      {required this.categoryId,
      required this.carModel,
      required this.firstName,
      required this.lastName,
      required this.location,
      required this.phone,
      required this.governorate});

  Map<String, dynamic> register() {
    return {
      "categoryId": categoryId,
      "carModel": carModel, // car model string
      "firstName": firstName,
      "lastName": lastName,
      "location": "الشروق",
      "phone": phone,
      "governorate": governorate
    };
  }
}
