// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fourtyninehub/features/trip_join/domain/entities/car_model_entity.dart';

class CarTypeModel extends CarModelEntity {
  CarTypeModel(super.model);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'model': model,
    };
  }

  factory CarTypeModel.fromJson(Map<String, dynamic> json) {
    return CarTypeModel(
      json['model'].toString(),
    );
  }
}
