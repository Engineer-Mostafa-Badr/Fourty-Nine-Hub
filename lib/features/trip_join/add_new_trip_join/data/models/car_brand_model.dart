// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/entities/car_brand_entity.dart';

class CarBrandModel extends CarBrandEntity {
  CarBrandModel(super.brand);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'brand': brand,
    };
  }

  factory CarBrandModel.fromJson(Map<String, dynamic> json) {
    return CarBrandModel(
      json['brand'] as String,
    );
  }
}
