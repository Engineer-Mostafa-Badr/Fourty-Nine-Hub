import 'package:fourtyninehub/features/RideFeature/domain/entities/drivers_in_subcategory_entity.dart';

class DriversInSubcategoryModel extends DriversInSubcategoryEntity{
  DriversInSubcategoryModel({required super.id, required super.userId});

  factory DriversInSubcategoryModel.fromJson(Map<String, dynamic> json) {
    return DriversInSubcategoryModel(
      id: json['_id'],
      userId: json['userId'],
    );
  }

}