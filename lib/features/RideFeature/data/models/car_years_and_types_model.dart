import 'package:fourtyninehub/features/RideFeature/domain/entities/car_years_and_types_entity.dart';

class CarsYearsAndTypesModel extends CarYearsAndTypesEntity{
  CarsYearsAndTypesModel({required super.year, required super.type, required super.id});

  //fromJson
  factory CarsYearsAndTypesModel.fromJson(Map<String, dynamic> json) {
    return CarsYearsAndTypesModel(
      year: json['Year'],
      type: json['type'],
      id: json['_id'],
    );
  }
}