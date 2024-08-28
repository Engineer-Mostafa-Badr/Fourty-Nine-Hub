// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fourtyninehub/features/trip_join/domain/entities/car_year_type_entity.dart';

class CarYearTypeModel extends CarYearTypeEntity {
  CarYearTypeModel({
    required super.year,
    required super.type,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Year': year,
      'type': type,
    };
  }

  factory CarYearTypeModel.fromJson(Map<String, dynamic> json) {
    return CarYearTypeModel(
      year: (json['Year'] ?? 'error').toString(),
      type: (json['type'] ?? 'error').toString(),
    );
  }
}
