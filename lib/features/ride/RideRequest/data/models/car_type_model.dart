import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/car_type_entity.dart';

class CarTypeModel extends CarTypeEntity {
  CarTypeModel(
      {required super.id,
      required super.brand,
      required super.model,
      required super.year,
      required super.type,
      required super.subCategory,

     });

  factory CarTypeModel.fromJson(Map<String, dynamic> json) {
    return CarTypeModel(
      id: json['id'],
      brand: json['brand']??'',
      model: json['model']??'',
      year: json['year']??'',
      type: json['type']??'',
      subCategory: json['sub_category']??0,



    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['brand'] = brand;
    data['model'] = model;
    data['year'] = year;
    data['type'] = type;
    data['sub_category'] = subCategory;

    return data;
  }
}
