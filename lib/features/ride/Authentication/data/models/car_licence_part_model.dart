import 'package:fourtyninehub/features/ride/Authentication/data/models/base_part_model.dart';

class CarLicencePartModel implements BasePartModel {
  String? carBrand;
  String? carModel;
  String? carYear;
  String? carColor;
  String? numberPlate;
  String? carRegisraion;
  String? backVehicleLicense;
  String? expiraionDate;
  String? carImage;
  CarLicencePartModel(
      {this.backVehicleLicense,
      this.carBrand,
      this.carColor,
      this.carImage,
      this.carModel,
      this.carRegisraion,
      this.carYear,
      this.expiraionDate,
      this.numberPlate});
  factory CarLicencePartModel.fromJson(Map<String, dynamic>? json) {
    return CarLicencePartModel(
        backVehicleLicense: json?['backVehicleLicense'],
        carBrand: json?['carBrand'],
        carColor: json?['carColor'],
        carImage: json?['carImage'],
        carModel: json?['carModel'],
        carRegisraion: json?['carRegisraion'],
        carYear: json?['carYear'],
        expiraionDate: json?['expiraionDate'],
        numberPlate: json?['numberPlate']);
  }
  @override
  toJson() {
    return {
      "backVehicleLicense": backVehicleLicense,
      "carBrand": carBrand,
      "carColor": carColor,
      "carImage": carImage,
      "carModel": carModel,
      "carRegisraion": carRegisraion,
      "carYear": carYear,
      "expiraionDate": expiraionDate,
      "numberPlate": numberPlate,
    };
  }
}
