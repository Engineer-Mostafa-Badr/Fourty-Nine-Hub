import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/car_type_entity.dart';

class CarTypeModel extends CarTypeEntity {
  const CarTypeModel(
      {required super.id, required super.brand, required super.model});

  factory CarTypeModel.fromJson(Map<String, dynamic> json) {
    return CarTypeModel(
      id: json['_id'],
      brand: json['Brand'],
      model: json['Model'],
    );
  }
}
